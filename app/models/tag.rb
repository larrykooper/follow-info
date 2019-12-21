# A Tag is a label used to categorize a Twitter user's tweets
#  in order to organize them into lists

# and keep track of who I follow.
class Tag < ActiveRecord::Base

  has_many :users

  # Class Methods

  def self.by_user_count
    Tag.joins(:users).where("users.i_follow").select("tags.name", "tags.id", "COUNT(tags.id) AS tags_count").group('tags.name, tags.id').order("tags_count DESC")
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
    Tag.joins(:users).distinct.sort_by {|tag| tag.name.downcase}
  end

  # Instance Methods

  def pifs_count
    users.where(:i_follow => true).count
  end

end