class UserObserver < ActiveRecord::Observer 
  def after_update(a_user)
    expire_fragment("user-#{a_user.id}") 
  end 
end