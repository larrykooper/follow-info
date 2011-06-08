# A Tag is a label used to categorize a Twitter user's tweets 
#  in order to organize them into lists
# and keep track of who I follow. 
class Tag < ActiveRecord::Base 
  has_and_belongs_to_many :users 
  
  def add_user(user)
    users << user 
  end
  
end