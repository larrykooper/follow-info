class TaggingObserver < ActiveRecord::Observer 
  def after_save(a_tagging) 
    ActionController::Base.new.expire_fragment("user-#{a_tagging.user.id}")
  end

end 