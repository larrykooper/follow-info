require File.dirname(__FILE__) + '/../spec_helper'

describe '.earlier' do
  it "returns the earlier one" do
    si = Factory(:system_info, :followers_last_update => 6.days.ago, :i_follow_last_update => 3.days.ago, :id => 1)
    SystemInfo.earlier.to_s.should == 6.days.ago.to_s     
  end 
  
end