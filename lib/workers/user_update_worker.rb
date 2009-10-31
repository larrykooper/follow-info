require 'rubygems'
gem('twitter4r', '>=0.2.1')
require 'twitter'

class UserUpdateWorker < BackgrounDRb::MetaWorker 
  set_worker_name :user_update_worker 
  set_no_auto_load(true)
  
  def create(args=nil)
    @logger.info "worker starting in create"
    cache['result'] = 0 
  end 
  
  def update_users(args = {})
    logger.info 'updating users now'  
    following_nbr = args[:following_nbr]   
    @twitter = Twitter::Client.new(:login => 'LarryKooper', :password => '3edocinu') 
    page_nbr = 1
    ending_ind = do_pif_page(page_nbr, following_nbr, @twitter, following_nbr)         
    while ending_ind > 0 
      # Go thru this loop once per each page of my PIFs 
      page_nbr += 1 
      start_ind = ending_ind 
      ending_ind = do_pif_page(page_nbr, start_ind, @twitter, following_nbr)
    end  
    exit     
  end
      
  def do_pif_page(page, starting_ind, twitter, following_nbr)  
    #logger.info "following_nbr is #{following_nbr}"       
    # Do a call to Twitter for one page of my PIFs 
    myfriends = twitter.my(:friends, :page => page) 
    #myfriends is an array    
    ind = starting_ind  # use the last index I used minus 1 
    myfriends.each do |pif|        
      # Process a PIF from Twitter 
      screen_name = pif.screen_name 
      user = User.find_by_name(screen_name)  # returns nil if not found 
      if user.nil?   
        User.create_new_pif(pif, ind) 
      else 
        user.process_pif(pif, ind) 
      end       
      ind -= 1  
      completed = following_nbr - ind 
      percent_complete = (completed * 100) / following_nbr    
      logger.info "Updating PIFs is #{percent_complete}% complete..."
      cache['result'] = percent_complete 
    end # myfriends.each 
    ind     
  end   # def do_pif_page 
  
end 