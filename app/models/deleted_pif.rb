# A Deleted Pif is a user that I used to follow who I either unfollowed, or their account was cancelled 
# The deleted ones are kept in this table until the next update of the PIF list 

class DeletedPif < ActiveRecord::Base 
  attr_accessible :name, :nbr_followers, :fmr_i_follow_nbr, :follows_me
  
end