class UsersController < ApplicationController

  def edit
    @user = User.find(params["id"])
  end

  # This code is used
  def update
    @user = User.find(params[:id])
    @user.tag_with_manually(params[:tags])
    flash[:notice] = 'User was successfully updated.'
    redirect_to :controller => "welcome", :action => 'list_pif', :sort => "i_follow_nbr", :direction => "desc"
  end

end