class Tagging < ActiveRecord::Base
  attr_accessible :tag, :twitter_user
  belongs_to :tag
  belongs_to :twitter_user
  
  def tag_name
    tag.name
  end
  
  def twitter_user_name
    twitter_user.name
  end
  
end