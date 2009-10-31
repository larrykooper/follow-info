# A user is one Twitter account
class User < ActiveRecord::Base 
  
  require 'math_stuff'
  
  def self.median_followers_of_pif 
    pif = self.find(:all, :conditions =>  "i_follow = 1") 
    my_array = pif.collect {|user| user.nbr_followers }
    med = MathStuff.median(my_array)    
  end
  
  def self.pifs_deleted 
    self.find(:all, :conditions => "taken_care_of = 0 AND i_follow = 1")
  end 
  
  def self.create_new_pif(pif, ind)
    user = User.new({:name => pif.screen_name,
      :nbr_followers => pif.followers_count, 
      :is_me => false,
      :i_follow => true,
      :i_follow_nbr => ind, 
      :taken_care_of => true})               
    user.save! 
  end 
   
  def process_pif(pif, ind) 
    # Update one user that I follow      
    unless self.i_follow   
      self.i_follow = true        
    end 
    self.nbr_followers = pif.followers_count 
    self.i_follow_nbr = ind 
    self.taken_care_of = true 
    self.save!                      
  end   
    
end 