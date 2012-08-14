# A Tag is a label used to categorize a Twitter user's tweets
#  in order to organize them into lists
# and keep track of who I follow.
class Tag < ActiveRecord::Base
  attr_accessible :name, :is_published
  has_many :followings
  has_many :follow_info_users_tags
  has_many :twitter_users, :through => :followings

  # Class Methods

  def self.by_twitter_user_count
    tags_hash = Tagging.joins(:tag).joins(:twitter_user).where("twitter_users.i_follow" => 't').count(:group => 'tags.name')
    tags_arr = tags_hash.sort { |a,b| b[1]<=>a[1] }
  end

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

  # Instance Methods

  def add_twitter_user_manually(twitter_user)
    Tagging.create(:tag => self, :twitter_user => twitter_user)
  end

  def pifs_count
    twitter_users.where(:i_follow => true).count
  end

end