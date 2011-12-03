# One-time task to restore data after Twitter rate limit caused me to lose data 
# 18 June 2011 

namespace :recovery do 
  task :recover_data => :environment do 
    file_path = "/users/larry/temp-restore/followinfo2.txt"
    recovery_file = File.open(file_path, 'r')  
    usercount = 0
    userstagged = 0
  
    while user_line = recovery_file.gets 
      myfields = user_line.split(/\t/)
      i_follow_nbr = myfields[0]
      username = myfields[1]
      tags_com_sep = myfields[2]      
      # Now add the user if not in table 
      userobj = User.find_by_name(username)
      if userobj.nil?
        puts ""
        puts "USER to add"
        puts username
        usercount = usercount + 1
        user = User.new({:name => username, 
          :i_follow => true,
          :follows_me => false        
        })
        user.save! 
        unless tags_com_sep.blank?
          userstagged = userstagged + 1
          user.tag_with_manually(tags_com_sep)        
        end 
      end           
    end       
    recovery_file.close 
    puts "users saved"
    puts usercount
    puts "users tagged"
    puts userstagged
  end
  
  task :recover_numbers => :environment do 
    file_path = "/users/larry/temp-restore/followinfo2.txt"
    recovery_file = File.open(file_path, 'r')  
    users_numbered = 0   
    while user_line = recovery_file.gets 
      myfields = user_line.split(/\t/)
      i_follow_nbr_f = myfields[0]
      username = myfields[1]     
      userobj = User.find_by_name(username)
      unless userobj.nil? 
        puts ""
        puts "USER"
        puts username
        unless userobj.i_follow_nbr
          users_numbered = users_numbered + 1
          userobj.i_follow_nbr = i_follow_nbr_f
          userobj.save! 
        end      
      end   
            
    end       
    recovery_file.close 
    puts "users numbered"
    puts users_numbered
  end
  
end