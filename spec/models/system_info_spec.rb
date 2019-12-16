require File.dirname(__FILE__) + '/../spec_helper'

describe '.earlier' do
  it "returns the earlier one" do
    six_days_ago = 6.days.ago
    si = SystemInfo.create(followers_last_update: six_days_ago, i_follow_last_update: 3.days.ago, id: 1)
    SystemInfo.earlier.to_s.should == six_days_ago.to_s
  end

end