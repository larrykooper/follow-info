require 'twitcon'

class UpdatePifsJob
  include Resque::Plugins::Status
  extend HerokuAutoScaler::AutoScaling  
  
  @queue = :pif_updating 
  
  def perform
    puts 'updating PIFs now'  
    following_nbr = options['nbr_following'] 
    cursor = "-1"
    ending_hash = do_pif_page(following_nbr, following_nbr, cursor, "")   
    screen_name_comp = ending_hash[:last_screen_name]
    cursor = ending_hash[:next_cursor]
    ending_ind = ending_hash[:ind]     
    puts "ending_ind before loop = #{ending_ind}"   
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
      puts "ending_ind in loop = #{ending_ind}"     # here is a printout 
    end     
    if ending_ind.nil? || ending_ind > 1 
      # Don't delete anything if we ended early 
      puts "UPDATE ENDED EARLY - Skipping finish_update_pifs"
      at(105, "UPDATE ENDED EARLY - Skipping finish_update_pifs")  # 105 is an error code
    elsif ending_ind == 1
      puts "Twitter's number of PIF was off by one"
      finish_update_pifs
      at(101, "Twitter's number of PIF was off by one - ignoring the error") # 101 is an error code 
    else     # assuming ending_ind is zero 
      finish_update_pifs  
    end
  end #perform
  
  def do_pif_page(starting_ind, following_nbr, cursor, last_sn_done)  
    # Do a call to Twitter for one page (c.100) of my PIFs 
    ret_hash = {}       
   
    twit_reply = Twitcon.my(:friends, :cursor => cursor)  # The call to Twitter 
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
      puts "size of myfriends = #{myfriends.size}"     # here is a printout 
    
      #myfriends is an array    
      ind = starting_ind  # use the last index I used minus 1 
      screen_name = ''
      myfriends.each do |pif|        
        # Process a PIF from Twitter 
        screen_name = pif['screen_name']
        if screen_name != last_sn_done # This line checks for Twitter's repeats 
          user = User.find_by_name(screen_name)  # returns nil if not found 
          if user.nil?   
            User.create_new_pif(pif, ind) 
          else 
            user.process_pif(pif, ind) 
          end       
          ind -= 1  
          completed = following_nbr - ind 
          percent_complete = (completed * 100) / following_nbr    
          puts "Updating PIFs is #{percent_complete}% complete..."
          at(percent_complete, "At #{percent_complete}")
          last_sn_done = screen_name 
        end 
      end
    end # myfriends.each 
    ret_hash[:ind] = ind
    ret_hash[:last_screen_name] = screen_name 
    ret_hash          
  end 
  
  def finish_update_pifs
    # Update system info 
    si = SystemInfo.find(1)
    si.i_follow_last_update = Time.now 
    si.save!       
    # Deal with the deleted (the users where taken_care_of is now false)
    gone_list = User.pifs_deleted 
    gone_list.each do |user|
      deleted_pif = DeletedPif.new({:name => user.name, 
        :nbr_followers => user.nbr_followers, 
        :i_follow_nbr => user.i_follow_nbr, 
        :follows_me => user.follows_me})
      deleted_pif.save! 
      if user.follows_me 
        user.i_follow = false 
        user.save! 
      else 
        user.destroy 
      end       
    end # gone_list.each do  

  end 
  
end 