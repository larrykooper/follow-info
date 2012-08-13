# A following is a following relationship between a Follow Info User and a Twitter User, 
# where either one follows the other or they both follow each other. 
# The Follow Info User may tag the Twitter User with at most one tag. 

class Following < ActiveRecord::Base 
  attr_accessible :follow_info_user_id, :twitter_user_id, :tu_follows_fiu, :fiu_follows_tu, :tag, :pif_number, :follower_number, :twitter_user, :follow_info_user 
  belongs_to :follow_info_user 
  belongs_to :twitter_user 
  belongs_to :tag 
  
  def self.for_user(user)
    Following.where(:follow_info_user_id => user.id)
  end
  
  def self.for_user_fiu_follows_tu(fiu) 
    Following.where(:follow_info_user_id => fiu.id, :fiu_follows_tu => true).includes(:twitter_user).order("pif_number desc") 
  end
  
  def self.for_user_tu_follows_fiu(fiu)
    Following.where(:follow_info_user_id => fiu.id, :tu_follows_fiu => true).includes(:twitter_user).order("follower_number desc")
  end
  
  def self.for_user_fiu_follows_tu_mini(fiu)
    Following.where(:follow_info_user_id => fiu.id, :fiu_follows_tu => true)
  end
  
  def self.for_user_tu_follows_fiu_mini(fiu)
    Following.where(:follow_info_user_id => fiu.id, :tu_follows_fiu => true)
  end

end