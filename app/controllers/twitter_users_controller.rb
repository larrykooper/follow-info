class TwitterUsersController < ApplicationController

  def edit
    @twitter_user = TwitterUser.find(params["id"])
    @tag = @twitter_user.tag(current_follow_info_user) # may be nil
    @tagname = @tag ? @tag.name : ""
    @tag_is_published = current_follow_info_user.fiu_tag_published?(@tag)
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