require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "earlier returns the earlier last update" do
    six_days_ago = 6.days.ago
    si = SystemInfo.create(followers_last_update: six_days_ago, i_follow_last_update: 3.days.ago, id: 1)
    assert_equal(six_days_ago.to_s, SystemInfo.earlier.to_s)

  end


end

