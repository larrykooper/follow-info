# System Info is a singleton class 
# It has id 1 
# It saves info about when things were updated 

class SystemInfo < ActiveRecord::Base 
  
  def self.earlier 
    si = self.find(1)
    si.followers_last_update < si.i_follow_last_update ? si.followers_last_update : si.i_follow_last_update 
  end 
  
end 