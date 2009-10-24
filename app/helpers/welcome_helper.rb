module WelcomeHelper 
  
  def earlier
    SystemInfo.earlier.strftime("%I:%M %p %m/%d/%y")    
  end
  
  def flu 
    si = SystemInfo.find(1)
    si.followers_last_update.blank? ? "never" : si.followers_last_update.strftime("%I:%M %p %m/%d/%y")
  end 
  
  def iflu
    si = SystemInfo.find(1)
    si.i_follow_last_update.strftime("%I:%M %p %m/%d/%y")
  end 
end