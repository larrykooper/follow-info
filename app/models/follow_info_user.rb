class FollowInfoUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model

  has_many :follow_info_users_tags
  has_many :followings
  has_many :deleted_followers
  has_many :deleted_pifs

  def fiu_tag(tag)
    # may be nil
    follow_info_users_tags.where(:tag_id => tag.id).first
  end

  def fiu_tag_published?(tag)
    if tag.nil?
      false
    else
      fiut = fiu_tag(tag)
      if fiut
        fiut.is_published
      else
        false
      end
    end
  end

  def pifs
    followings.where(:fiu_follows_tu => true)
  end

  def pifs_with_join
    Following.where(:follow_info_user_id => self.id, :fiu_follows_tu => true).includes(:twitter_user)
  end

  def pif_count
    followings.where(:fiu_follows_tu => true).count
  end

  def follower_count
    followings.where(:tu_follows_fiu => true).count
  end

  def pif_follower_count
    Following.where(:follow_info_user_id => self.id, :fiu_follows_tu => true, :tu_follows_fiu => true).count
  end

  def median_followers_of_pifs
    my_array = pifs_with_join.collect {|following| following.twitter_user.nbr_followers }
    med = MathStuff.median(my_array)
  end

  def mean_followers_of_pifs
    my_array = pifs_with_join.collect {|following| following.twitter_user.nbr_followers }
    mean = MathStuff.mean(my_array)
  end

  # used_tags is the list (de-duped) of tags such that the FIU currently has at least one TU with that tag
  def used_tags
    Tag.find_by_sql(["SELECT DISTINCT tags.* FROM tags " +
         "INNER JOIN followings " +
         "ON tags.id = followings.tag_id " +
         "WHERE follow_info_user_id = ? " +
         "AND fiu_follows_tu = 't' ",
          self.id])
  end

  def used_tags_sorted
      Tag.find_by_sql(["SELECT DISTINCT LOWER(tags.name), tags.* FROM tags " +
           "INNER JOIN followings " +
           "ON tags.id = followings.tag_id " +
           "WHERE follow_info_user_id = ? " +
           "AND fiu_follows_tu = 't' " +
           "ORDER BY LOWER(tags.name)",
            self.id])
  end

  def update_pifs
    # Update entire list of TUs that the FIU follows (aka PIFs)
    # From Twitter to the local database
    # Fiirst clear out deleted_pifs
    DeletedPif.clear_out_for(self)
    # For all FIU's followings, set taken_care_of to false, because we haven't taken care of any yet.
    ActiveRecord::Base.connection.execute("UPDATE followings SET taken_care_of = false WHERE follow_info_user_id = " + self.id)
    # Call Resque worker
    @pifs_job_id = UpdatePifsJob.create(:fiu => self)
    @pifs_job_id
  end

  def update_follers
    # Update entire list of people who follow the FIU
    # From Twitter to the local database
    # First clear out deleted_followers
    DeletedFollower.clear_out_for(self)
    # For all FIU's followings, set taken_care_of to false, because we haven't taken care of any yet.
    ActiveRecord::Base.connection.execute("UPDATE followings SET taken_care_of = false WHERE follow_info_user_id = " + self.id)
    # Call Resque worker
    @follers_job_id = UpdateFollowersJob.create(:follers_nbr => self.follower_count)
    @follers_job_id
  end


end
