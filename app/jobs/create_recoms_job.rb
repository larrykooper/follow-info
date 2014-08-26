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
    # In most cases, my PIF will follow less than 5,000 people.
    # But sometimes (NYTFridge, +) they follow more than 5,000.
    pifs.each do |pif|
    # process one PIF that was passed to job
    	puts "larrylog: doing #{pif}"
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
  end # if friend_lookup_ok
  end # process_5000_ppfs




end # class CreateRecomsJob