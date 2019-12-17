
require 'test_helper'


class ShowingPIFPageTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  def setup
    sign_in FactoryBot.create(:follow_info_user)
  end

  test "shows PIF page" do
    get "/welcome/list_pif"
    assert_response :success
    assert_select "h1", "People I follow - 0"
  end

end
