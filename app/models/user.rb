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
   
end 