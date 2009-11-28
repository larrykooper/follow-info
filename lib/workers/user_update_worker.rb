require 'rubygems'
gem('twitter4r', '>=0.2.1')
require 'twitter'

class UserUpdateWorker < BackgrounDRb::MetaWorker 
  set_worker_name :user_update_worker 
  set_no_auto_load(true)
  
  def create(args=nil)
    @logger.info "PIF update worker starting in create"
    cache['result'] = 0 
  end 
  
  def update_users(args = {})
    logger.info 'updating PIFs now'  
    following_nbr = args[:following_nbr]       
    cursor = "-1"
    ending_hash = do_pif_page(following_nbr, following_nbr, cursor, "")   
    screen_name_comp = ending_hash[:last_screen_name]
    cursor = ending_hash[:next_cursor]
    ending_ind = ending_hash[:ind]     
    logger.info "ending_ind before loop = #{ending_ind}"   
    my_status = 'unfinished'      
    if ending_ind.nil?  # this means twitter had a problem 
      my_status = 'finished'
    end  
    while (ending_ind && ending_ind > 0 && my_status == 'unfinished')
      # Go thru this loop once per each page of my PIFs        
      start_ind = ending_ind 
      ending_hash = do_pif_page(start_ind, following_nbr, cursor, screen_name_comp)
      screen_name_comp = ending_hash[:last_screen_name]
      cursor = ending_hash[:next_cursor]
      ending_ind = ending_hash[:ind]
      my_status = ending_hash[:status]
      if ending_ind.nil?  # this means twitter had a problem 
        my_status = 'finished'
      end
      logger.info "ending_ind in loop = #{ending_ind}"   
    end  
    exit     
  end
      
  def do_pif_page(starting_ind, following_nbr, cursor, last_sn_done)  
    # Do a call to Twitter for one page of my PIFs 
    ret_hash = {}       
   
    twit_reply = Twitcon.my(:friends, :cursor => cursor) 
    if twit_reply.nil?
      ret_hash[:status] = 'finished'
      ret_hash[:last_screen_name] = ""
      ret_hash[:ind] = starting_ind 
      ret_hash[:next_cursor] = 0       
    else 
      next_cursor = twit_reply["next_cursor"]
      ret_hash[:next_cursor] = next_cursor
      myfriends = twit_reply["users"]
      ret_hash[:status] = myfriends.size == 0 ? 'finished' : 'unfinished'
      if ret_hash[:status] == 'finished'
        cache['result'] = 100
      end 
      logger.info "size of myfriends = #{myfriends.size}"   
    
      #myfriends is an array    
      ind = starting_ind  # use the last index I used minus 1 
      screen_name = ''
      myfriends.each do |pif|        
        # Process a PIF from Twitter 
        screen_name = pif['screen_name']
        if screen_name != last_sn_done 
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
          last_sn_done = screen_name 
        end 
      end
    end # myfriends.each 
    ret_hash[:ind] = ind
    ret_hash[:last_screen_name] = screen_name 
    ret_hash      
  end   # def do_pif_page 
  
end 