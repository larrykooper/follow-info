# A MyQuitter is a user who used to follow me but now does not.  
# The spammers and jerks who unfollow me are kept in this table until the 
# next update of the follower list. 

class MyQuitter < ActiveRecord::Base 
  attr_accessible :name, :fmr_follows_me_nbr, :i_follow
end