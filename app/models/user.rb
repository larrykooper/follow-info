# A user is one Twitter account
class User < ActiveRecord::Base 
  
  require 'math_stuff' 
  
  def self.median_followers_of_pif 
    pif = User.where(:i_follow => 1)  
    my_array = pif.collect {|user| user.nbr_followers }
    med = MathStuff.median(my_array)    
  end
  
  def self.pifs_deleted 
    User.where("taken_care_of = 0 AND i_follow = 1")
  end 
  
  def self.quitters 
   User.where("taken_care_of = 0 AND follows_me = 1")
  end  
  
  # Add a new person I follow from the Twitter API 
  def self.create_new_pif(pif, ind)
    last_time_tweeted = pif['status'].nil? ? nil :  pif['status']['created_at']
    user = User.new({:name => pif['screen_name'],
      :nbr_followers => pif['followers_count'], 
      :last_time_tweeted => last_time_tweeted,
      :is_me => false,
      :follows_me => false,
      :i_follow => true,
      :i_follow_nbr => ind, 
      :taken_care_of => true})               
    user.save! 
  end 
  
  def self.larrys_foller_count
    # So I do not need to call API 
    User.where("follows_me = 1").count    
  end 
  
  def self.larry_following_count
    User.where("i_follow = 1").count  
  end 
   
  def process_pif(pif, ind) 
    last_time_tweeted = pif['status'].nil? ? nil :  pif['status']['created_at']
    # Update one user that I follow      
    unless self.i_follow   
      self.i_follow = true        
    end     
    self.nbr_followers = pif['followers_count']
    self.last_time_tweeted = last_time_tweeted
    self.i_follow_nbr = ind 
    self.taken_care_of = true
    self.save!                      
  end   
  
  def self.create_new_foller(foller, ind)     
     user = User.new({:name => foller['screen_name'],
      :nbr_followers => foller['followers_count'],       
      :is_me => false,
      :follows_me => true,
      :i_follow => false,
      :follows_me_nbr => ind, 
      :taken_care_of => true})               
    user.save!       
  end 
  
  def process_foller(foller, ind)    
    # Update one user who follows me
    unless self.follows_me
      self.follows_me = true        
    end 
    self.nbr_followers = foller['followers_count'] 
    self.follows_me_nbr = ind 
    self.taken_care_of = true    
    self.save!          
  end 
    
end 