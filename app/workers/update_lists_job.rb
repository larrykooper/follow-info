require "twitter_oauth/twitter_oauth"

class UpdateListsJob < Resque::JobWithStatus 
  
  @queue = :list_updating
  @@client = TwitterOAuth::Client.new   
  @@ACCOUNT_NAME = 'LarryKooper'
  @@file_path = "/users/larry/twitter/badlistusers.txt"   
  @@myfile = File.open(@@file_path, 'w') 
  
  def perform
    puts 'updating lists now'    
    hshLists = @@client.get_lists(ACCOUNT_NAME)   # Get all my public lists 
    if hshLists["error"]
      puts "Twitter error, rate limit exceeded"
    else    
      arrLists = hshLists["lists"] 
      arrLists.each do |list|             
        process_a_list(list)
      end         
    end    
    @@myfile.close
    finish_update_lists 
  end
  
  def process_a_list(list)
    listname = list["slug"]  
    puts "Starting " + listname 
    mytag = Tag.find_by_name(listname)
    tag_id = mytag.id
    arrMembers = @@client.list_all_members(@@ACCOUNT_NAME, listname)
    arrMembers.each do |member|    
      username = member["screen_name"]
      puts username
      userobj = User.find_by_name(username) 
      if userobj && userobj.i_follow        
        user_id = userobj.id
        tagging = Tagging.find_by_user_id_and_tag_id(user_id, tag_id)
        if tagging.nil? 
          Tagging.create_from_twit_list_entry(user_id, tag_id)
        else 
          tagging.process_twit_list_entry(user_id, tag_id)
        end 
      else 
        @@myfile.puts "I DO NOT FOLLOW " + username + " ON LIST " + listname + "\n"  
      end           
    end    
  end
  
  def finish_update_lists 
    # Update system info 
    si = SystemInfo.find(1)
    si.lists_last_update = Time.now
    si.save! 
    untagged_taggings_list = Tagging.taggings_deleted 
    untagged_taggings_list.each do |tagging|
      deleted_tagging = DeletedTagging.new({:tag_name => tagging.tag_name,
        :user_name => tagging.user_name})
      deleted_tagging.save! 
      tagging.destroy 
    end
  end   
end