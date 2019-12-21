class FollowInfoUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

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


end
