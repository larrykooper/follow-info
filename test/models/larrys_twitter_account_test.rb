require 'test_helper'
require 'net/http'

class LarrysTwitterAccountTest < ActiveSupport::TestCase

# We don't call the real Twitter API in these two tests

  test "Number following returned is correct" do
    # This simulates the response that the Twitter API returns:
    my_info =
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<user>\n  <id>2615611</id>\n  <name>Larry Kooper</name>\n  <screen_name>Larry Kooper</screen_name>\n  <location>New York City</location>\n  <description>fr&#233;missements d'une feuille effac&#233;e</description>\n  <profile_image_url>http://a3.twimg.com/profile_images/547144879/Photo_45_normal.jpg</profile_image_url>\n  <url>http://stormville.blogspot.com</url>\n  <protected>false</protected>\n  <followers_count>259</followers_count>\n  <profile_background_color>9ae4e8</profile_background_color>\n  <profile_text_color>000000</profile_text_color>\n  <profile_link_color>0000ff</profile_link_color>\n  <profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>\n  <profile_sidebar_border_color>87bc44</profile_sidebar_border_color>\n  <friends_count>813</friends_count>\n  <created_at>Wed Mar 28 04:44:36 +0000 2007</created_at>\n  <favourites_count>14</favourites_count>\n  <utc_offset>-18000</utc_offset>\n  <time_zone>Eastern Time (US &amp; Canada)</time_zone>\n  <profile_background_image_url>http://a1.twimg.com/profile_background_images/56390270/IMG_3173.JPG</profile_background_image_url>\n  <profile_background_tile>true</profile_background_tile>\n  <notifications></notifications>\n  <geo_enabled>true</geo_enabled>\n  <verified>false</verified>\n  <following></following>\n  <statuses_count>442</statuses_count>\n  <lang>en</lang>\n  <contributors_enabled>false</contributors_enabled>\n  <status>\n    <created_at>Mon Feb 15 19:07:47 +0000 2010</created_at>\n    <id>9152013976</id>\n    <text>NPR's Michael Sullivan journeys to the source of the Mekong River in Tibet  http://bit.ly/c9cncv</text>\n    <source>web</source>\n    <truncated>false</truncated>\n    <in_reply_to_status_id></in_reply_to_status_id>\n    <in_reply_to_user_id></in_reply_to_user_id>\n    <favorited>false</favorited>\n    <in_reply_to_screen_name></in_reply_to_screen_name>\n    <geo/>\n    <contributors/>\n  </status>\n</user>\n"
    larry = LarrysTwitterAccount.instance
    Net::HTTP.stubs(:get).returns(my_info)
    f = larry.nbr_following
    assert_equal(813, f)
  end

  test "Number of followers is correct" do
    my_info =
    "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<user>\n  <id>2615611</id>\n  <name>Larry Kooper</name>\n  <screen_name>Larry Kooper</screen_name>\n  <location>New York City</location>\n  <description>fr&#233;missements d'une feuille effac&#233;e</description>\n  <profile_image_url>http://a3.twimg.com/profile_images/547144879/Photo_45_normal.jpg</profile_image_url>\n  <url>http://stormville.blogspot.com</url>\n  <protected>false</protected>\n  <followers_count>259</followers_count>\n  <profile_background_color>9ae4e8</profile_background_color>\n  <profile_text_color>000000</profile_text_color>\n  <profile_link_color>0000ff</profile_link_color>\n  <profile_sidebar_fill_color>e0ff92</profile_sidebar_fill_color>\n  <profile_sidebar_border_color>87bc44</profile_sidebar_border_color>\n  <friends_count>813</friends_count>\n  <created_at>Wed Mar 28 04:44:36 +0000 2007</created_at>\n  <favourites_count>14</favourites_count>\n  <utc_offset>-18000</utc_offset>\n  <time_zone>Eastern Time (US &amp; Canada)</time_zone>\n  <profile_background_image_url>http://a1.twimg.com/profile_background_images/56390270/IMG_3173.JPG</profile_background_image_url>\n  <profile_background_tile>true</profile_background_tile>\n  <notifications></notifications>\n  <geo_enabled>true</geo_enabled>\n  <verified>false</verified>\n  <following></following>\n  <statuses_count>442</statuses_count>\n  <lang>en</lang>\n  <contributors_enabled>false</contributors_enabled>\n  <status>\n    <created_at>Mon Feb 15 19:07:47 +0000 2010</created_at>\n    <id>9152013976</id>\n    <text>NPR's Michael Sullivan journeys to the source of the Mekong River in Tibet  http://bit.ly/c9cncv</text>\n    <source>web</source>\n    <truncated>false</truncated>\n    <in_reply_to_status_id></in_reply_to_status_id>\n    <in_reply_to_user_id></in_reply_to_user_id>\n    <favorited>false</favorited>\n    <in_reply_to_screen_name></in_reply_to_screen_name>\n    <geo/>\n    <contributors/>\n  </status>\n</user>\n"
    larry = LarrysTwitterAccount.instance
    Net::HTTP.stubs(:get).returns(my_info)
    f = larry.nbr_of_followers
    assert_equal(259, f)
  end

end