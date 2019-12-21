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

  def is_tag_published(tag)
    tag ? yes_no(tag.is_published) : "no"
  end

  # This is displayed when I edit
  # It only displays tags that are CURRENTLY USED
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

  def published(is_published)
    is_published ? " class='published" : ""
  end

  # Creates the column headers with sorting links in the HTML
  def sortable(column, title = nil)
    title ||= column.titleize
    # Link to reverse direction if you click again
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

end