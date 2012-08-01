class TwitterUsersController < ApplicationController 
  
  def edit    
    @twitter_user = TwitterUser.find(params["id"])   	
  end
  
  def update
    @twitter_user = TwitterUser.find(params[:id])
    @twitter_user.tag_with_manually(params[:tags])   
    flash[:notice] = 'Twitter User was successfully updated.'
    # invalidate cache
    expire_fragment("twitter_user-#{@twitter_user.id}")
    redirect_to :controller => "welcome", :action => 'list_pif', :sort => "i_follow_nbr", :direction => "desc"
  end 
  
end 