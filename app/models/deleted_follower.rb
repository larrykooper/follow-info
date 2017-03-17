# A DeletedFollower is a Twitter user who used to follow me but now does not.
# The Twitter users who unfollow me are kept in this table until the
# next update of the follower list.

class DeletedFollower < ActiveRecord::Base
  belongs_to :follow_info_user

  def clear_out_for(follow_info_user)
    DeletedFollower.where(:follow_info_user_id => follow_info_user.id).destroy_all
  end

end