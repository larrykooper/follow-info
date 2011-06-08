# A Tag is a label used to categorize a Twitter user's tweets 
#  in order to organize them into lists
# and keep track of who I follow. 
class Tag < ActiveRecord::Base 
  has_many :taggings
  has_many :users, :through => :taggings  
  
  def self.used_tags 
    where(:taggings.size > 0).order('name')
  end   
  
  def add_user(user)
    users << user 
  end
  
end