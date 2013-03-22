require 'rubygems'
require 'singleton'
require 'xml/libxml'

# This class is a singleton that models my Twitter account. 
class LarrysTwitterAccount
  include Singleton 
  extend HerokuAutoScaler::AutoScaling  
  
  def foller_update_status(job_id)       
    @status = Resque::Plugins::Status::Hash.get(job_id)
    @status 
  end

  # Does a live update from Twitter 
  def nbr_following
    q_string = "/users/show.xml?screen_name=LarryKooper" 
    response = Net::HTTP.get API_ROOT_URL, q_string     
    parser = XML::Parser.string(response, :encoding => XML::Encoding::UTF_8)
    resp_doc = parser.parse
    nbr = 0
    resp_doc.find('//user/friends_count').each do |n|    
      nbr = n.child.to_s.to_i
    end
    nbr 
  end 

  def nbr_of_followers 
    q_string = "/users/show.xml?screen_name=LarryKooper" 
    response = Net::HTTP.get API_ROOT_URL, q_string     
    parser = XML::Parser.string(response, :encoding => XML::Encoding::UTF_8)
    resp_doc = parser.parse
    nbr = 0 
    resp_doc.find('//user/followers_count').each do |n|    
      nbr = n.child.to_s.to_i
    end
    nbr 
  end 
    
  def pif_update_status(job_id)
    @status = Resque::Plugins::Status::Hash.get(job_id)
    @status     
  end    
  
  def update_all_pif 
    # Update entire list of people I follow 
    # From Twitter to my database 
    larry = LarrysTwitterAccount.instance
    # nbr_following = larry.nbr_following  # Does a live update from Twitter 
    ActiveRecord::Base.connection.execute("TRUNCATE deleted_pifs")
    # For all users, set taken_care_of to false 
    ActiveRecord::Base.connection.execute("UPDATE users SET taken_care_of = false")
    # Call Resque worker
    @pifs_job_id = UpdatePifsJob.create() 
    @pifs_job_id 
  end   

def update_follers     
    # Update entire list of people who follow me 
    # From Twitter to my database 
    larry = LarrysTwitterAccount.instance
    #follers_nbr = larry.nbr_of_followers  
    ActiveRecord::Base.connection.execute("TRUNCATE my_quitters")
    # For all users, set taken_care_of to false; taken_care_of is a temp column
    ActiveRecord::Base.connection.execute("UPDATE users SET taken_care_of = false")
    # Call Resque worker
    @follers_job_id = UpdateFollowersJob.create()           
    @follers_job_id   
  end  

end  # class LarrysTwitterAccount