# A Deleted Pif is a user that I used to follow who I either unfollowed, or their account was cancelled 
# The deleted ones are kept in this table until the next update of the PIF list 

class DeletedPif < ActiveRecord::Base
  belongs_to :follow_info_user
  attr_accessible :name, :nbr_followers, :fmr_i_follow_nbr, :follows_me
  
  def clear_out_for(follow_info_user)
    DeletedPif.where(:follow_info_user_id => follow_info_user.id).destroy_all
  end
  
end