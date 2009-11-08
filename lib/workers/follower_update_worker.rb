require 'rubygems'
gem('twitter4r', '>=0.2.1')
require 'twitter'

class FollowerUpdateWorker < BackgrounDRb::MetaWorker 
  set_worker_name :follower_update_worker 
  set_no_auto_load(true)
  
  def create(args=nil)
    @logger.info "follower_update_worker starting in create"
    cache['result'] = 0 
  end 
  
  def update_followers(args = {})
    logger.info 'updating followers now'  
    follers_nbr = args[:follers_nbr]   
    logger.info "follers_nbr = #{follers_nbr}"   
    #@twitter = Twitter::Client.new(:login => 'LarryKooper', :password => '3edocinu') 
    page_nbr = 1  
    cursor = "-1"
    ending_hash = do_follers_page(page_nbr, follers_nbr, follers_nbr, cursor)  
    cursor = ending_hash[:next_cursor]
    ending_ind = ending_hash[:ind]  
    logger.info "ending_ind before loop = #{ending_ind}"   
    my_status = 'unfinished'  
    while (ending_ind > 0 && my_status == 'unfinished')
      # Go thru this loop once per each page of my followers 
      page_nbr += 1 
      start_ind = ending_ind 
      ending_hash = do_follers_page(page_nbr, start_ind, follers_nbr, cursor)
      cursor = ending_hash[:next_cursor]
      ending_ind = ending_hash[:ind]
      my_status = ending_hash[:status]
      logger.info "ending_ind in loop = #{ending_ind}"     
    end  
    exit     
  end
        
  def do_follers_page(page, starting_ind, follers_nbr, cursor)        
    # Do a call to Twitter for one page of my followers  
    ret_hash = {}
    
    twit_reply = Twitcon.my(:followers, :cursor => cursor)
    # parse the reply 
    next_cursor = twit_reply["next_cursor"]
    ret_hash[:next_cursor] = next_cursor
    myfollers = twit_reply["users"]
    
    ret_hash[:status] = myfollers.size == 0 ? 'finished' : 'unfinished'
    if ret_hash[:status] == 'finished'
      cache['result'] = 100
    end 
    logger.info "size of myfollers = #{myfollers.size}"
    
    #myfollers is an array    
    ind = starting_ind  # use the last index I used minus 1, which is ending_ind  
    myfollers.each do |foller|        
      # Process a follower from Twitter 
      screen_name = foller['screen_name'] 
      user = User.find_by_name(screen_name)  # returns nil if not found 
      logger.info "ind is #{ind}"
      if user.nil?   
        User.create_new_foller(foller, ind) 
      else 
        user.process_foller(foller, ind)   
      end       
      ind -= 1  
      completed = follers_nbr - ind   
      percent_complete = (completed * 100) / follers_nbr    
      logger.info "Updating my followers is #{percent_complete}% complete..."
      cache['result'] = percent_complete 
    end # myfollers.each   
    ret_hash[:ind] = ind   
    
    ret_hash    
  end   # def do_follers_page 
  
end 
