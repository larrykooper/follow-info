class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :user
  
  # CLASS METHODS 
  def self.create_from_twit_list_entry(user_id, tag_id)
    tagging = Tagging.new({:tag_id => tag_id, 
      :user_id => user_id, 
      :is_published => true,
      :taken_care_of => true})
    tagging.save! 
  end  
  
  def self.taggings_deleted 
    sex_tag = Tag.find_by_name("sex")
    # Sex taggings for now will not be taken_care_of since they are private 
    # But we can't assume if not TCO they are deleted 
    Tagging.where("taken_care_of = 0 AND is_published = 1 AND tag_id != ?", sex_tag.id)
  end 
    
  # INSTANCE METHODS 
  def process_twit_list_entry(user_id, tag_id)
    self.is_published = true  # Because coming from Twitter 
    self.taken_care_of = true 
    self.save!
  end  
  
  def tag_name
    tag.name
  end
  
  def user_name
    user.name
  end
  
end