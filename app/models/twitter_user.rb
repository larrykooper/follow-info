# A twitter_user is one Twitter account.
# It could be somebody I follow or someone who follows me, 
# or both.

class TwitterUser < ActiveRecord::Base 
  attr_accessible :name, :nbr_followers, :follows_me, :i_follow, :i_follow_nbr, :follows_me_nbr, :taken_care_of, :last_time_tweeted
  has_many :taggings, :dependent => :destroy   
  has_many :tags, :through => :taggings
  
  require 'math_stuff' 

  # CLASS METHODS   
  def self.create_new_foller(foller, ind)     
     twitter_user = TwitterUser.new({:name => foller.screen_name,
      :nbr_followers => foller.followers_count,
      :follows_me => true,
      :i_follow => false,
      :follows_me_nbr => ind, 
      :taken_care_of => true})               
    twitter_user.save!       
  end 
  
  # Add a new person I follow from the Twitter API 
  def self.create_new_pif(pif, ind)
    last_time_tweeted = pif.status.nil? ? nil : pif.status['created_at']
    twitter_user = TwitterUser.new({:name => pif.screen_name,
      :nbr_followers => pif.followers_count, 
      :last_time_tweeted => last_time_tweeted,
      :follows_me => false,
      :i_follow => true,
      :i_follow_nbr => ind, 
      :taken_care_of => true})               
    twitter_user.save! 
  end  
  
  def self.pifs_deleted 
    TwitterUser.where("taken_care_of = false AND i_follow = true")
  end 
  
  def self.followers_deleted 
   TwitterUser.where("taken_care_of = false AND follows_me = true")
  end  
  
  # PUBLIC INSTANCE METHODS 
  
 def process_foller(foller, ind)    
    # Update one twitter_user who follows me
    unless self.follows_me
      self.follows_me = true        
    end 
    self.nbr_followers = foller.followers_count 
    self.follows_me_nbr = ind 
    self.taken_care_of = true    
    self.save!          
  end    
  
  def process_pif(pif, ind) 
    last_time_tweeted = pif.status.nil? ? nil : pif.status['created_at']
    # Update one twitter_user that I follow      
    unless self.i_follow   
      self.i_follow = true        
    end     
    self.nbr_followers = pif.followers_count
    self.last_time_tweeted = last_time_tweeted if last_time_tweeted 
    self.i_follow_nbr = ind 
    self.taken_care_of = true
    self.save!   
    # invalidate cache
    ActionController::Base.new.expire_fragment("twitter_user-#{self.id}")                   
  end      
  
  def tag_list
     (tags.collect {|tag| tag.name }).join(", ") 
  end   
 
  def tag_with_manually(list)
    Tag.transaction do
      taggings.destroy_all
      Tag.parse(list).each do |name|        
        Tag.find_or_create_by_name(name).add_twitter_user_manually(self)        
      end
    end   
  end  
    
end 