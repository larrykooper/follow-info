# A FollowInfoUser is a user of the follow-info app, i.e. someone who wants to track and tag who they follow on Twitter.

class FollowInfoUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
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
  
end
