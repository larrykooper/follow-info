require 'twitter'

class UpdateFollowersJob
  include Resque::Plugins::Status

  @queue = :follower_updating

  def perform
    puts 'UpdateFollowersJob started'
    @@done_count = 0
    if defined? CLIENT
      @@tclient = CLIENT
    else
      @@tclient = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token = ENV["TWITTER_OAUTH_TOKEN"]
        config.access_token_secret = ENV["TWITTER_OAUTH_TOKEN_SECRET"]
      end
    end
    done_with_all_follers = false
    while not done_with_all_follers
      ending_hash = do_5000_follers
      if ending_hash[:next_cursor] == 0
        done_with_all_follers = true
      end
    end
    if ending_hash[:api_status] == "ok"
      finish_update_follers
    else
      puts "We did not end normally -- not deleting anything. Error message: #{ending_hash[:api_status]}"
    end
  end # def perform

  def do_5000_follers
    ret_hash = {}
    ret_hash[:api_status] = "ok"
    followers_lookup_ok = true
    begin
      twitter_reply = @@tclient.follower_ids('larrykooper') # Call Twitter
    rescue
      puts "Twitter call follower_ids caused error!"
      p $!
      puts $@
      # end further processing
      followers_lookup_ok = false
      ret_hash[:api_status] = "Follower lookup caused error"
    end
    if followers_lookup_ok
      puts "I just successfully called follower_ids"
      next_cursor = twitter_reply.next_cursor
      ret_hash[:next_cursor] = next_cursor
      follers = twitter_reply.collection
      @@follers_page_size = follers.size
      puts "follers_page_size: #{@@follers_page_size}"
      done_with_follers_page = false
      starting = 0
      user_lookup_ok = true
      while not done_with_follers_page
        ending = starting + 99
        puts "starting: #{starting}, ending: #{ending}"
        user_lookup_ok = do_100(follers[starting..ending])
        if !user_lookup_ok
          ret_hash[:api_status] = "User lookup caused error"
          done_with_follers_page = true # we stop
        end
        if ending >= (@@follers_page_size - 1)
          done_with_follers_page = true
        end
        starting = ending + 1
      end
    end
    ret_hash
  end # do_5000_follers

  def do_100(follers)
    user_lookup_ok = true
    begin
      twitter_user_info = @@tclient.users(follers) # Call Twitter; this returns an array of Twitter::User objects
    rescue
      puts "Twitter call users/lookup caused error!"
      p $!
      puts $@
      # end further processing
      user_lookup_ok = false
    end
    if user_lookup_ok
      puts "just did user/lookup"
      twitter_user_info.each do |foller|
        puts "doing #{foller.screen_name}"
        @@done_count += 1
        @@ind = @@follers_page_size + 1 - @@done_count
        # Process a follower against User table
        user = User.find_by_name(foller.screen_name) # returns nil if not found
        if user.nil?
          User.create_new_foller(foller, @@ind)
        else
          user.process_foller(foller, @@ind)
        end
        fps = @@follers_page_size
        percent_complete = (@@done_count * 100) / fps
        at(percent_complete, @@follers_page_size, "At #{percent_complete}")
        puts "done count: #{@@done_count} of #{@@follers_page_size}"
        puts "ind: #{@@ind}"
      end
    end
    user_lookup_ok
  end # do_100

  def finish_update_follers
   # Update system info
    si = SystemInfo.find(1)

    si.followers_last_update = Time.now
    si.save!
    # Deal with the twitter_users who have unfollowed me
    unfollowed_me_list = User.quitters
    unfollowed_me_list.each do |user|
      unfollower = DeletedFollower.new({:name => user.name,
        :fmr_follower_number => user.follows_me_nbr,
        :i_follow => user.i_follow})
      unfollower.save!
      if user.i_follow
        user.follows_me = false
        user.save!
      else
        user.destroy
      end
    end # unfollowed_me_list.each do
  end

end # class
