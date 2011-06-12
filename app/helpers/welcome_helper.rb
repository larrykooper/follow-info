module WelcomeHelper 
  
  def earlier
    SystemInfo.earlier.strftime("%l:%M %p %m/%d/%y")    
  end
  
  def flu 
    si = SystemInfo.find(1)
    si.followers_last_update.blank? ? "never" : si.followers_last_update.strftime("%l:%M %p %m/%d/%y")
  end 
  
  def iflu
    si = SystemInfo.find(1)
    si.i_follow_last_update.strftime("%l:%M %p %m/%d/%y")
  end 
  
  def yes_no(value)
    value ? 'yes' : 'no'
  end
  
  def display_tags(taggings)
    if taggings.empty? 
      "no"
    else 
      yes_no(taggings.first.is_published)            
    end  
  end
  
  def all_my_tags 
    taglist = ""
    Tag.used_tags.each do |tag|
      taglist << "<span class='tagName"
      taglist << " published" if tag.is_published 
      taglist << "'>"
      taglist << tag.name 
      taglist << "</span>"
    end
    taglist.html_safe
  end 
  
  def tags_display_for(tag_arr)
    taglist = ""
    tag_arr.each do |tag|
      taglist << "<span"
      taglist << " class='published'" if tag.is_published 
      taglist << ">"
      taglist << tag.name
      taglist << "</span>"
      taglist << ", " unless tag_arr.last == tag
    end 
    taglist.html_safe     
  end
  
end