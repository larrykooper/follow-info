# A following is a following relationship between a Follow Info User and a Twitter User, 
# where either one follows the other or they both follow each other. 
# The Follow Info User may tag the Twitter User with at most one tag. 

class Following < ActiveRecord::Base 
  attr_accessible :tag, :twitter_user, :follow_info_user 
  belongs_to :follow_info_user 
  belongs_to :twitter_user 
  belongs_to :tag 
end