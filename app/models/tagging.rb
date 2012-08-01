class Tagging < ActiveRecord::Base
  attr_accessible :tag, :user, :is_published
  belongs_to :tag
  belongs_to :user
  
  def tag_name
    tag.name
  end
  
  def user_name
    user.name
  end
  
end