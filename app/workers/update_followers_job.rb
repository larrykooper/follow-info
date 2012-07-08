require 'twitcon'

class UpdateFollowersJob
  include Resque::Plugins::Status
  # THIS IS THE Resque WORKER 
  # Also known as the "job class"
  
  @queue = :follower_updating 
  
  def perform   
    puts 'updating followers now'     
    follers_nbr = options['follers_nbr'].to_i  
    puts "follers_nbr = #{follers_nbr}"          
    cursor = "-1"
    ending_hash = do_follers_page(follers_nbr, follers_nbr, cursor, "")  
    screen_name_comp = ending_hash[:last_screen_name]
    cursor = ending_hash[:next_cursor]
    ending_ind = ending_hash[:ind]  
    puts "ending_ind before loop = #{ending_ind}"   
    my_status = 'unfinished'  
    while (ending_ind > 0 && my_status == 'unfinished')
      # Go thru this loop once per each page of my followers      
      start_ind = ending_ind 
      ending_hash = do_follers_page(start_ind, follers_nbr, cursor, screen_name_comp)
      screen_name_comp = ending_hash[:last_screen_name]
      cursor = ending_hash[:next_cursor]
      ending_ind = ending_hash[:ind]
      my_status = ending_hash[:status]
      puts "ending_ind in loop = #{ending_ind}"     
    end  
    finish_update_follers
    puts "finished updating followers"   
  end # self.perform
    
  def do_follers_page(starting_ind, follers_nbr, cursor, last_sn_done)        
    # Do a call to Twitter for one page of my followers  
    ret_hash = {}
    
    twit_reply = Twitcon.my(:followers, :cursor => cursor)
    if twit_reply.nil? 
      ret_hash[:status] = 'finished'
      ret_hash[:last_screen_name] = ""
      ret_hash[:ind] = starting_ind 
      ret_hash[:next_cursor] = 0
    else  
      # parse the reply 
      next_cursor = twit_reply["next_cursor"]
      ret_hash[:next_cursor] = next_cursor
      myfollers = twit_reply["users"]
    
      ret_hash[:status] = myfollers.size == 0 ? 'finished' : 'unfinished'      
      puts "size of myfollers = #{myfollers.size}"
    
      #myfollers is an array    
      ind = starting_ind  # use the last index I used minus 1, which is ending_ind  
      screen_name = ''
      myfollers.each do |foller|        
        # Process a follower from Twitter 
        screen_name = foller['screen_name'] 
        if screen_name != last_sn_done 
          user = User.find_by_name(screen_name)  # returns nil if not found 
          puts "ind is #{ind}"
          if user.nil?   
            User.create_new_foller(foller, ind) 
          else 
            user.process_foller(foller, ind)   
          end       
          ind -= 1  
          completed = follers_nbr - ind   
          percent_complete = (completed * 100) / follers_nbr    
          puts "Updating my followers is #{percent_complete}% complete..."         
          at(percent_complete, "At #{percent_complete}")          
          last_sn_done = screen_name 
        end
      end # myfollers.each   
      ret_hash[:ind] = ind   
      ret_hash[:last_screen_name] = screen_name 
    end     
    ret_hash    
  end   # def do_follers_page 
  
  def finish_update_follers 
    # Update system info 
    si = SystemInfo.find(1)
    si.followers_last_update = Time.now 
    si.save!    
    # Deal with the quitters 
    quitter_list = User.quitters   
    quitter_list.each do |user|    
      quitter = MyQuitter.new({:name => user.name,         
        :fmr_follows_me_nbr => user.follows_me_nbr, 
        :i_follow => user.i_follow})
      quitter.save! 
      if user.i_follow
        user.follows_me = false 
        user.save! 
      else 
        user.destroy 
      end       
    end # quitter_list.each do      
  end 
    
end 