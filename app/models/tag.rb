# A Tag is a label used to categorize a Twitter user's tweets 
#  in order to organize them into lists
# and keep track of who I follow. 
class Tag < ActiveRecord::Base 
  has_many :taggings
  has_many :users, :through => :taggings  
  
  # input is a delimited list of tags 
  # output is an array of tags 
  def self.parse(list)
    tag_names = []

    # first, pull out the quoted tags
    list.gsub!(/\"(.*?)\"\s*/ ) { tag_names << $1; "" }

    # then, replace all commas with a space
    list.gsub!(/,/, " ")

    # then, get whatever's left
    tag_names.concat list.split(/\s/)

    # strip whitespace from the names
    tag_names = tag_names.map { |t| t.strip }

    # delete any blank tag names
    tag_names = tag_names.delete_if { |t| t.empty? }
    
    return tag_names
  end  
  
  def self.used_tags 
    where(:taggings.size > 0).order('name')
  end   
  
  def add_user_manually(user)
    # We set is_published to false 
    # because manually added tags are not published    
    Tagging.create(:tag => self, :user => user, :is_published => false)    
  end
  
end