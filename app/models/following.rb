# A following is a following relationship between a Follow Info User and a Twitter User, 
# where either one follows the other or they both follow each other. 
# The Follow Info User may tag the Twitter User with at most one tag. 

class Following < ActiveRecord::Base 
  attr_accessible :follow_info_user_id, :twitter_user_id, :tu_follows_fiu, :fiu_follows_tu, :tag, :pif_number, :follower_number, :twitter_user, :follow_info_user 
  belongs_to :follow_info_user 
  belongs_to :twitter_user 
  belongs_to :tag 
  
  def self.for_user(user)
    # This is all of the TUs the FIU follows
    Following.where(:follow_info_user_id => user.id)
  end
  
  def self.for_user_fiu_follows_tu(fiu)
    # This is the info about PIFs for an FIU
    Following.where(:follow_info_user_id => fiu.id, :fiu_follows_tu => true).includes(:twitter_user).order("pif_number desc") 
  end
  
  def self.for_user_tu_follows_fiu(fiu)
    # This is the info about followers for the FIU
    Following.where(:follow_info_user_id => fiu.id, :tu_follows_fiu => true).includes(:twitter_user).order("follower_number desc")
  end
  
  def self.process_pif_for_current_user(fiu, pif, index)
    #lkhere
  end
  
  def tag_with(tag_name)
    tag = Tag.find_or_create_by_name(tag_name)
    self.tag = tag
    self.save
  end

end