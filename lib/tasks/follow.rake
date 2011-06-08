# NOTE 
# Need to write this to accommodate Twitter's rate limits 
# So (1) recover from Twitter errors 
# and (2) Don't start all over if screws up, start from where left off

require "twitter_oauth/twitter_oauth"

ACCOUNT_NAME='LarryKooper'

namespace :follow do
  task :set_all_tags => :environment do
    file_path = "/users/larry/twitter/badlistusers.txt"   
    myfile = File.open(file_path, 'w') 
    client = TwitterOAuth::Client.new   
    hshLists = client.get_lists(ACCOUNT_NAME) 
    if hshLists["error"]
      puts "Twitter error, rate limit exceeded"
    else    
      arrLists = hshLists["lists"] 
      arrLists.each do |list|             
        process_a_list(list, client, myfile)
      end  
      # process_a_list(arrLists[0], client, myfile)  # delete me  
    
      # puts Tag.all.inspect-- that did work 
    end
    myfile.close
  end
  
  def process_a_list(list, client, myfile)
    listname = list["slug"]  
    puts "Starting " + listname 
    mytag = Tag.find_by_name(listname)
    arrMembers = client.list_all_members(ACCOUNT_NAME, listname)
    # member = arrMembers[0] # delete me
    arrMembers.each do |member|    
      username = member["screen_name"]
      puts username
      userobj = User.find_by_name(username)
      if userobj && userobj.i_follow 
        mytag.add_user(userobj)
      else 
        myfile.puts listname + ", " + username + "\n"  
      end      
    end
  end 
  
end