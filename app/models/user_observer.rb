class UserObserver < ActiveRecord::Observer 
  def after_update(a_user)
    ActionController::Base.new.expire_fragment("user-#{a_user.id}") 
  end 
end