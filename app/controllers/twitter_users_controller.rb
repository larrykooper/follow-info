class TwitterUsersController < ApplicationController

  def edit
    @twitter_user = TwitterUser.find(params["id"])
    @tag = @twitter_user.tag(current_follow_info_user) # may be nil
    @tagname = @tag ? @tag.name : ""
    @tag_is_published = current_follow_info_user.fiu_tag_published?(@tag)
  end

  def update
    @twitter_user = TwitterUser.find(params[:id])
    following = Following.find_by_follow_info_user_id_and_twitter_user_id(current_follow_info_user.id, params[:id])
    following.tag_with(params[:tag])    
    flash[:notice] = 'Twitter User was successfully updated.'
    # invalidate cache
    expire_fragment("twitter_user-#{@twitter_user.id}")
    redirect_to :controller => "welcome", :action => 'list_pif', :sort => "i_follow_nbr", :direction => "desc"
  end

end