# A FollowInfoUser is a user of the follow-info app, i.e. someone who wants to track and tag who they follow on Twitter.

class FollowInfoUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :follow_info_users_tags
  has_many :followings

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
    Following.for_user_fiu_follows_tu_mini(self)
  end

  def pifs_with_join
    Following.where(:follow_info_user_id => self.id, :fiu_follows_tu => true).includes(:twitter_user)
  end

  def pif_count
    Following.for_user_fiu_follows_tu_mini(self).count
  end

  def follower_count
    Following.for_user_tu_follows_fiu_mini(self).count
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

end
