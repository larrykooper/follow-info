class TagObserver < ActiveRecord::Observer 
  def after_update(a_tag)
    a_tag.users.each do |user|
      ActionController::Base.new.expire_fragment("user-#{user.id}")
    end 
  end 
end