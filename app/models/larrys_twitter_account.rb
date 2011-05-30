require 'rubygems'
require 'singleton'
require 'xml/libxml'

# This class is a singleton that models my Twitter account. 
class LarrysTwitterAccount
  include Singleton 
  
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
    
  def self.pif_update_status 
    # TODO - REIMPLEMENT THE PROGRESS BAR   
    #@status = MiddleMan.worker(:user_update_worker).ask_result("result")
    #@status 
  end 
  
  def self.foller_update_status   
    # TODO - REIMPLEMENT THE PROGRESS BAR   
    #@status = MiddleMan.worker(:follower_update_worker).ask_result("result") 
    #@status 
  end 
  
  def update_follers     
    # Update entire list of people who follow me 
    # From Twitter to my database 
    larry = LarrysTwitterAccount.instance
    follers_nbr = larry.nbr_of_followers  
    ActiveRecord::Base.connection.execute("TRUNCATE my_quitters")
    # For all users, set taken_care_of to false; taken_care_of is a temp column
    ActiveRecord::Base.connection.execute("UPDATE users SET taken_care_of = 0")     
    # Call Resque worker
    Resque.enqueue(UpdateFollowers, follers_nbr)          
  end 

   def update_all_pif 
    # Update entire list of people I follow 
    # From Twitter to my database 
    larry = LarrysTwitterAccount.instance
    following_nbr = larry.nbr_following  
    ActiveRecord::Base.connection.execute("TRUNCATE deleted_pifs")
    # For all users, set taken_care_of to false 
    ActiveRecord::Base.connection.execute("UPDATE users SET taken_care_of = 0")     
    # Call Resque worker
    Resque.enqueue(UpdatePifs, following_nbr)  
  end   

end  # class LarrysTwitterAccount