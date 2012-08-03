# A FollowInfoUsersTag is a pairing of one Follow Info User and one Tag. 
# It keeps track of whether this individual FI User publishes this Tag.
# In future, can get this from the Twitter Lists API and/or publish it TO the lists API. 

class FollowInfoUsersTag < ActiveRecord::Base 
  attr_accessible :follow_info_user, :tag, :is_published 
  belongs_to :follow_info_user
  belongs_to :tag 
end