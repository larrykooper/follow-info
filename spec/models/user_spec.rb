require File.dirname(__FILE__) + '/../spec_helper'

describe '.create_new_pif' do
  it "creates and saves a new person I follow (pif)" do 
    pif = {'screen_name' => 'Calvin', 
      'followers_count' => 287}
    ind = 120
    User.create_new_pif(pif, ind)
    calv = User.find_by_name('Calvin')
    calv.should_not be_nil 
    calv.nbr_followers.should == 287    
  end  
end 

describe '#process_pif' do 
  it "should update the user's number of followers" do
    user = Factory(:user)
    pif = {'followers_count' => 48}
    ind = 39
    user.process_pif(pif, ind)
    user.nbr_followers.should == 48
    user.i_follow_nbr.should == 39
  end
end 

describe '.create_new_foller' do
  it "creates and saves a new user" do
    foller = {'screen_name' => 'Marvin',
      'followers_count' => 801}
    ind = 298
    User.create_new_foller(foller, ind)
    marv = User.find_by_name("Marvin")
    marv.should_not be_nil
    marv.follows_me_nbr.should == 298 
    marv.nbr_followers.should == 801
  end
end 

describe '#process_foller' do
  it "should update the user's number of followers" do
    user = Factory(:user) 
    ind = 329 
    foller = {'followers_count' => 453}
  
    user.process_foller(foller, ind)
    user.nbr_followers.should == 453
    user.follows_me_nbr.should == 329
  
  end
end 