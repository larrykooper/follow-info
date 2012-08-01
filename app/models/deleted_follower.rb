# A DeletedFollower is a Twitter user who used to follow me but now does not.  
# The Twitter users who unfollow me are kept in this table until the 
# next update of the follower list. 

class DeletedFollower < ActiveRecord::Base 
  attr_accessible :name, :fmr_follows_me_nbr, :i_follow
end