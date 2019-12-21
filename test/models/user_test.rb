require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "create_new_pif creates and saves a new person I follow (pif)" do
    pif = Twitter::User.new(id: 4533, screen_name: 'Calvin', followers_count: 287, status: nil)
    ind = 120
    User.create_new_pif(pif, ind)
    calv = User.find_by_name('Calvin')
    refute_nil(calv)
    assert_equal(287, calv.nbr_followers)

  end

  test "process_pif should update the user's number of followers" do
    user = User.new
    pif = Twitter::User.new(id: 4535, followers_count: 48, status: nil)
    ind = 39
    user.process_pif(pif, ind)
    assert_equal(48, user.nbr_followers)
    assert_equal(39, user.i_follow_nbr)
  end

  test "create_new_foller should create and save a new user" do
    foller = Twitter::User.new(id: 67584, screen_name: 'Marvin', followers_count: 801)
    ind = 298
    User.create_new_foller(foller, ind)
    marv = User.find_by_name("Marvin")
    refute_nil(marv)
    assert_equal(298, marv.follows_me_nbr)
    assert_equal(801, marv.nbr_followers)
  end

  test "process_foller should update the user's number of followers" do
    user = User.new
    ind = 329
    foller = Twitter::User.new(id: 58958, followers_count: 453)
    user.process_foller(foller, ind)
    assert_equal(453, user.nbr_followers)
    assert_equal(329, user.follows_me_nbr)
  end

  test "Users should, default, be sorted by i_follow_number in descending order" do
    pif1 = create(:pif, last_time_tweeted: "2019-07-01 13:00", i_follow_nbr: 2)
    pif2 = create(:pif, last_time_tweeted: "2019-10-01 13:00", i_follow_nbr: 1)
    pif3 = create(:pif, last_time_tweeted: "2019-09-01 13:00", i_follow_nbr: 3)
    piflist = User.paginated_pifs(50, 1, "i_follow_nbr", "desc")
    assert_equal(3, piflist[0].i_follow_nbr)
    assert_equal(2, piflist[1].i_follow_nbr)
  end

end