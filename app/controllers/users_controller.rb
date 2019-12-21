class UsersController < ApplicationController

  def edit
    @user = User.find_by(id: params["id"])
  end

  # This code is used when I update a user's tag
  def update
    @user = User.find_by(id: params["id"])
    tag = Tag.find_or_create_by(name: params["tag"])
    @user.tag = tag
    @user.save!
    flash[:notice] = 'User was successfully updated.'
    redirect_to :controller => "welcome", :action => 'list_pif', :sort => "i_follow_nbr", :direction => "desc"

  end

end