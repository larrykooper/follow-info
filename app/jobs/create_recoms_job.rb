require 'twitcon'

# Idea - a subset of user's PIFs (those with a given tag) (an array)
# will be passed into the job. Passing all of my 1,800+
# PIFs would be unwieldy; Also, I probably want recommendations
# for a tag.

# PIF -> person I follow
# PPF -> Person my PIF follows

# CURRENT VERSION IGNORES RATE LIMITING
# RL SUPPORT TO BE ADDED LATER

class CreateRecomsJob
  include Resque::Plugins::Status
  extend HerokuAutoScaler::AutoScaling

  @queue = :recommending

  def perform
    puts 'larrylog: CreateRecomsJob started'
    pifs = options['pifs']
    @@input_size = pifs.size
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
    on_count = 0
    # In most cases, my PIF will follow less than 5,000 people.
    # But sometimes (NYTFridge, +) they follow more than 5,000.
    pifs.each do |pif|
    # process one PIF that was passed to job
      on_count += 1
    	puts "larrylog: doing #{pif}"
      puts "larrylog: doing #{on_count} of #{@@input_size}"
    	done_with_this_pif = false
    	while not done_with_this_pif
    		ending_hash = process_5000_ppfs(pif)
    		if ending_hash[:next_cursor] == 0
    		  done_with_this_pif = true
    		end
    	end # while not done_with_this_pif
    end # pifs.each do

  end # perform

  def process_5000_ppfs(username)
  	ret_hash = {}
    ret_hash[:api_status] = "ok"
    friend_lookup_ok = true
    begin
  	  twitter_reply = @@tclient.friend_ids({:screen_name => username})
    rescue
  	  puts "Twitter call friend_ids caused error!"
      p $!
      puts $@
      # end further processing
      friend_lookup_ok = false
      ret_hash[:api_status] = "Friend lookup caused error"
    end
    if friend_lookup_ok
      puts "larrylog: I just successfully called friend_ids"
      next_cursor = twitter_reply.next_cursor
      ret_hash[:next_cursor] = next_cursor
      ppfs = twitter_reply.ids
      #puts ppfs
      @@ppfs_size = ppfs.size
      puts "larrylog: PPFs size: #{@@ppfs_size}"
      if @@ppfs_size == 0
        done_with_ppfs_page = true
      else
        done_with_ppfs_page = false
      end
      starting = 0
      user_lookup_ok = true
      while not done_with_ppfs_page
        ending = starting + 99
        puts "larrylog: starting: #{starting}, ending: #{ending}"
        user_lookup_ok = do_100(ppfs[starting..ending])
        if !user_lookup_ok
          ret_hash[:api_status] = "User lookup caused error"
          done_with_ppfs_page = true  #we stop
        end
        if ending >= (@@ppfs_size - 1)
          done_with_ppfs_page = true
        end
        starting = ending + 1
      end # while not done_with_ppfs_page
    end # if friend_lookup_ok
    ret_hash
  end # process_5000_ppfs

  def do_100(ppfs)
    user_lookup_ok = true
    begin
       twitter_user_info = @@tclient.users(ppfs) # Call Twitter; this returns an array of Twitcon::User objects
    rescue
      puts "Twitter call users/lookup caused error!"
      p $!
      puts $@
      # end further processing
      user_lookup_ok = false
    end
    if user_lookup_ok
      puts "larrylog: just successfully did user lookup"
      twitter_user_info.each do |ppf|
        puts "larrylog: processing #{ppf.screen_name}"
        # see if the PPF has a user record
        user = User.find_by_name(ppf.screen_name)  # returns nil if not found
        if user.nil?
          user = User.create_new_ppf(ppf)
        end
        if !(user.i_follow)
          user.bump_recommend_count
        end # if I don't follow user
      end
    end # if user_lookup_ok
    user_lookup_ok
  end # do_100

end # class CreateRecomsJob