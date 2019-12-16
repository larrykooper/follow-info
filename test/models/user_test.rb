require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "I can do it" do

    pif = Twitter::User.new(id: 4533, screen_name: 'Calvin', followers_count: 287, status: nil)
    ind = 120
    User.create_new_pif(pif, ind)
    calv = User.find_by_name('Calvin')
    refute_nil(calv)
    assert_equal(287, calv.nbr_followers)

  end

end