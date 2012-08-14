class WelcomeController < ApplicationController 
  before_filter :authenticate_follow_info_user!
  helper_method :sort_column, :sort_direction 
	
  def check_foller_update_status    
    larry = LarrysTwitterAccount.instance 
    @follers_job_id = params[:follers_job_id]        
    if request.xhr?
      @status = larry.foller_update_status(@follers_job_id)      
      response = {:mystatus => @status["status"], :pct => @status["num"]}
      render json: response
    end
  end 

  def check_pif_update_status
    larry = LarrysTwitterAccount.instance
    @pifs_job_id = params[:pifs_job_id]
    @pct = 0
    if request.xhr?
      @status = larry.pif_update_status(@pifs_job_id)
      response = {:mystatus => @status["status"], :pct => @status["num"]}
      render json: response
    end  
  end   
  
  def index 
    @following = current_follow_info_user.pif_count 
    @followers = current_follow_info_user.follower_count  
  end

  def list_follers
    @followings = Following.for_user_tu_follows_fiu(current_follow_info_user)
    @count = @followings.size
  end  
  
  def list_idropped       
    sort_clause = "fmr_i_follow_nbr DESC"
    @deleted_pifs = DeletedPif.order(sort_clause)   
  end
  
  def list_pif
    @followings = Following.for_user_fiu_follows_tu(current_follow_info_user) 
    @count = @followings.size 
  end   
  
  def list_stats
    @following = current_follow_info_user.pif_count  
    @followers = current_follow_info_user.follower_count 
    @pif_folling = current_follow_info_user.pif_follower_count
    @pif_folling_pct = @pif_folling * 100 / @following
    @median_fol = current_follow_info_user.median_followers_of_pifs 
    @mean_fol = current_follow_info_user.mean_followers_of_pifs   
  end
  
  def list_unfollowed     
    sort_clause = "fmr_follows_me_nbr DESC"
    @deleted_followers = DeletedFollower.order(sort_clause)
  end   
  
  def update_follers
    follers_job_id = current_follow_info_user.update_follers
    redirect_to :action => 'check_foller_update_status', :follers_job_id => follers_job_id
  end  
  
  def update_pif    
    pifs_job_id = current_follow_info_user.update_pifs
    redirect_to :action => 'check_pif_update_status', :pifs_job_id => pifs_job_id
  end     
    
  private 
  
  def sort_column
    TwitterUser.column_names.include?(params[:sort]) ? params[:sort] : @sort_column_default
  end
  
  def sort_direction 
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end  
      
end