require 'rubygems'
gem('twitter4r', '>=0.2.1')
require 'singleton'
require 'twitter'
require 'xml/libxml'

class Larry
  include Singleton 
  
  def nbr_following
    q_string = "/users/show.xml?screen_name=LarryKooper" 
    response = Net::HTTP.get API_ROOT_URL, q_string     
    parser = XML::Parser.string(response, :encoding => XML::Encoding::UTF_8)
    resp_doc = parser.parse
    nbr = 0
    resp_doc.find('//user/friends_count').each do |n|    
      nbr = n.child.to_s.to_i
    end
    nbr 
  end 

  def nbr_of_followers 
    q_string = "/users/show.xml?screen_name=LarryKooper" 
    response = Net::HTTP.get API_ROOT_URL, q_string     
    parser = XML::Parser.string(response, :encoding => XML::Encoding::UTF_8)
    resp_doc = parser.parse
    nbr = 0 
    resp_doc.find('//user/followers_count').each do |n|    
      nbr = n.child.to_s.to_i
    end
    nbr 
  end 
  
  def update_all_pif 
    # Update entire list of people I follow 
    # From Twitter to my database 
    larry = Larry.instance
    following_nbr = larry.nbr_following  
    ActiveRecord::Base.connection.execute("TRUNCATE deleted_pifs")
    # For all users, set taken_care_of to false 
    ActiveRecord::Base.connection.execute("UPDATE users SET taken_care_of = 0")
    @twitter = Twitter::Client.new(:login => 'LarryKooper', :password => '3edocinu') 
    page_nbr = 1
    ending_ind = larry.do_pif_page(page_nbr, following_nbr)
    while ending_ind > 0 
      page_nbr += 1 
      start_ind = ending_ind 
      ending_ind = larry.do_pif_page(page_nbr, start_ind)
    end 
    # Update system info 
    si = SystemInfo.find(1)
    si.i_follow_last_update = Time.now 
    si.save!   
    
    # Deal with the deleted 
    gone_list = User.pifs_deleted 
    gone_list.each do |user|
      deleted_pif = DeletedPif.new({:name => user.name, 
        :nbr_followers => user.nbr_followers, 
        :i_follow_nbr => user.i_follow_nbr, 
        :i_followed => user.i_follow})
      deleted_pif.save! 
      if user.follows_me 
        user.i_follow = false 
        user.save! 
      else 
        user.destroy 
      end 
      
    end # gone_list.each do  
  end 
  
  def do_pif_page(page, starting_ind)     

    myfriends = @twitter.my(:friends, :page => page) 
    #myfriends is an array    

    ind = starting_ind  # use the last index I used minus 1 

    myfriends.each do |pif|        
      # Process a PIF from Twitter 
      screen_name = pif.screen_name 
      user = User.find_by_name(screen_name)  # returns nil if not found 
      if user.nil? 
        # a new PIF      
        
        user = User.new({:name => pif.screen_name,
        :nbr_followers => pif.followers_count, 
        :is_me => false,
        :i_follow => true,
        :i_follow_nbr => ind, 
        :taken_care_of => true})               
        user.save! 

      else 
        unless user.i_follow   
          user.i_follow = true        
        end 
        user.nbr_followers = pif.followers_count 
        user.i_follow_nbr = ind 
        user.taken_care_of = true 
        user.save!                  
      end  
      
      ind -= 1  
      
    end # myfriends.each 
    ind     
  end   # def do_pif_page 

end  # class Larry