class UpdatePifsJob
  include Resque::Plugins::Status
  extend HerokuAutoScaler::AutoScaling  
  
  @queue = :pif_updating 
  
  def perform
    puts 'updatePifsJob started'
    @@done_count = 0
    if defined? CLIENT
      @@tclient = CLIENT
    else 
      @@tclient = Twitcon::Client.new(
        :consumer_key => ENV["TWITTER_CONSUMER_KEY"],
        :consumer_secret => ENV["TWITTER_CONSUMER_SECRET"],
        :oauth_token => ENV["TWITTER_OAUTH_TOKEN"],
        :oauth_token_secret => ENV["TWITTER_OAUTH_TOKEN_SECRET"]
      )
    end
    done_with_all_pifs = false
    while not done_with_all_pifs
      ending_hash = do_5000_pifs
      if ending_hash[:next_cursor] == 0
        done_with_all_pifs = true
      end
    end
    if ending_hash[:api_status] == "ok"
      finish_update_pifs
    else
      puts "we did not end normally - not deleting anything. Error message: #{ending_hash[:api_status]} "
    end
  end # def perform

  def do_5000_pifs
    ret_hash = {}
    ret_hash[:api_status] = "ok"
    friend_lookup_ok = true
    begin
      twitter_reply = @@tclient.friend_ids # Call Twitter; this returns at most 5,000 IDs. It actually returns a Twitcon::Cursor object
    rescue
      puts "Twitter call friend_ids caused error!"
      puts "#{$!}"
      # end further processing
      friend_lookup_ok = false
      ret_hash[:api_status] = "Friend lookup caused error"
    end
    if friend_lookup_ok
      puts "I just successfully called friend_ids"
      next_cursor = twitter_reply.next_cursor
      ret_hash[:next_cursor] = next_cursor
      pifs = twitter_reply.ids
      @@friends_page_size = pifs.size
      puts "friends_page_size: #{@@friends_page_size}"
      done_with_friends_page = false
      starting = 0
      user_lookup_ok = true
      while not done_with_friends_page
        ending = starting + 99
        puts "starting: #{starting}, ending: #{ending}"
        user_lookup_ok = do_100(pifs[starting..ending])
        if !user_lookup_ok
          ret_hash[:api_status] = "User lookup caused error"
          done_with_friends_page = true  #we stop
        end
        if ending >= (@@friends_page_size - 1)
          done_with_friends_page = true
        end 
        starting = ending + 1
      end
    end
    ret_hash
  end  # do_5000_pifs

  def do_100(pifs)
    user_lookup_ok = true
    begin
      twitter_user_info = @@tclient.users(pifs) # Call Twitter; this returns an array of Twitcon::User objects
    rescue
      puts "Twitter call users/lookup caused error!"
      puts "#{$!}"
      # end further processing
      user_lookup_ok = false
    end
    if user_lookup_ok
      puts "just did user/lookup"
      twitter_user_info.each do |pif|
        puts "doing #{pif.screen_name}"
        @@done_count += 1
        @@ind = @@friends_page_size + 1 - @@done_count
        # Process a PIF against User table
        user = User.find_by_name(pif.screen_name)  # returns nil if not found
        if user.nil?
          User.create_new_pif(pif, @@ind)
        else
          user.process_pif(pif, @@ind)
        end
        percent_complete = (@@done_count * 100) / @@friends_page_size # TODO fix this for users who follow > 5000 people
        #puts "Updating PIFs is #{percent_complete}% complete..."
        at(percent_complete, "At #{percent_complete}")
        puts "done count: #{@@done_count} of #{@@friends_page_size}"
        puts "ind: #{@@ind}"
      end
    end
    user_lookup_ok
  end # do_100
  
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

end # class UpdatePifsJob