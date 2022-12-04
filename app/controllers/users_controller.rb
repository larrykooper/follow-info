class UsersController < ApplicationController

  def edit
    session[:return_to] = request.referrer
    @user = User.find_by(id: params["id"])
  end

  # This code is used when I update a user's tag
  def update
    @user = User.find_by(id: params["id"])
    tag = Tag.find_or_create_by(name: params["tag"])
    @user.tag = tag
    @user.save!
    flash[:notice] = 'User was successfully updated.'
    redirect_to session[:return_to]
  end

end