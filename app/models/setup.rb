class Setup     
  
  def self.do_first_page   
    
    #require('rubygems')
    gem('twitter4r', '>=0.2.1')
    require('twitter')
    twitter = Twitter::Client.new(:login => 'LarryKooper', :password => '3edocinu') 

    myfriends = twitter.my(:friends) 

    #myfriends is an array 

    # THIS IS WHAT WE DO TO INITIALLY SET UP THE 
    # LIST OF PEOPLE I FOLLOW

    following_nbr = 580

    ind = 580 

    myfriends.each do |pif|
  
      user = User.new({:name => pif.screen_name,
        :nbr_followers => pif.followers_count, 
        :is_me => false,
        :i_follow => true,
        :i_follow_nbr => ind})
      user.save! 

      ind -= 1  
    end 
  end   
  
  def self.do_second_page   
    
    #require('rubygems')
    gem('twitter4r', '>=0.2.1')
    require('twitter')
    twitter = Twitter::Client.new(:login => 'LarryKooper', :password => '3edocinu') 

    myfriends = twitter.my(:friends, :page => 2) 

    #myfriends is an array 

    # THIS IS WHAT WE DO TO continue to SET UP THE 
    # LIST OF PEOPLE I FOLLOW

    ind = 481  # use the last index I used minus 1 

    myfriends.each do |pif|
  
      user = User.new({:name => pif.screen_name,
        :nbr_followers => pif.followers_count, 
        :is_me => false,
        :i_follow => true,
        :i_follow_nbr => ind})
      user.save! 

      ind -= 1  
      puts ind 
    end 
  end   
  
  # Note- I called this successively with:  
  #   3, 381
  #   4, 283
  #   5, 185
  #   6, 85
  #
  
  def self.do_page(page, starting_ind)      
    
    gem('twitter4r', '>=0.2.1')
    require('twitter')
    twitter = Twitter::Client.new(:login => 'LarryKooper', :password => '3edocinu') 

    myfriends = twitter.my(:friends, :page => page) 

    #myfriends is an array 

    # THIS IS WHAT WE DO TO continue to SET UP THE 
    # LIST OF PEOPLE I FOLLOW

    ind = starting_ind  # use the last index I used minus 1 

    myfriends.each do |pif|
  
      user = User.new({:name => pif.screen_name,
        :nbr_followers => pif.followers_count, 
        :is_me => false,
        :i_follow => true,
        :i_follow_nbr => ind})
      user.save! 

      ind -= 1  
      puts ind 
    end 
  end 
  
  #-------------------------------------------------------------------------------  
   
  # Note- I called this successively with:  
  # 1, 204
  # 2, 138
  # 3, 69 
  
  def self.do_followers_page(page, starting_ind)      
    
    gem('twitter4r', '>=0.2.1')
    require('twitter')
    twitter = Twitter::Client.new(:login => 'LarryKooper', :password => '3edocinu') 

    myfollowers = twitter.my(:followers, :page => page) 

    #myfollowers is an array 

    # THIS IS WHAT WE DO TO SET UP THE 
    # LIST OF PEOPLE WHO FOLLOW ME 

    ind = starting_ind  # use the last index I used minus 1 

    myfollowers.each do |foller|
      
      user = User.find_by_name(foller.screen_name)
      if user.nil?    
        user = User.new({:name => foller.screen_name,
          :nbr_followers => foller.followers_count, 
          :is_me => false,
          :follows_me => true,
          :follows_me_nbr => ind})
        user.save!
      else 
        user.follows_me = true
        user.follows_me_nbr = ind
        user.save!  
      end       

      ind -= 1  
      #puts ind 
    end 
  end 
  
end