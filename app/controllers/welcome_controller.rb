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
    @following = TwitterUser.where(:i_follow => true).count 
    @followers = TwitterUser.where(:follows_me => true).count
  end

  def list_follers 
    @sort_column_default = 'follows_me_nbr'
    @sort_direction_default = 'desc'
    @follers = TwitterUser.where(:follows_me => true).order(sort_column + " " + sort_direction)   
    @count = @follers.size
  end  
  
  def list_idropped       
    sort_clause = "fmr_i_follow_nbr DESC"
    @deleted_pifs = DeletedPif.order(sort_clause)   
  end
  
  def list_pif  
    @sort_column_default = 'i_follow_nbr'   
    @sort_direction_default = 'desc'
    @twitter_users = TwitterUser.where(:i_follow => true).order(sort_column + " " + sort_direction)  
    @count = @twitter_users.size 
  end   
  
  def list_stats
    @following = TwitterUser.larry_following_count 
    @followers = TwitterUser.larrys_foller_count
    @pif_folling = TwitterUser.pif_following_me_count
    @pif_folling_pct = @pif_folling * 100 / @following
    @median_fol = TwitterUser.median_followers_of_pif 
    @mean_fol = TwitterUser.where(:i_follow => true).average(:nbr_followers)     
  end
  
  def list_unfollowed     
    sort_clause = "fmr_follows_me_nbr DESC"
    @deleted_followers = DeletedFollower.order(sort_clause)
  end   
  
  def update_follers 
    larry = LarrysTwitterAccount.instance 
    follers_job_id = larry.update_follers
    redirect_to :action => 'check_foller_update_status', :follers_job_id => follers_job_id
  end  
  
  def update_pif    
    larry = LarrysTwitterAccount.instance 
    pifs_job_id = larry.update_all_pif  
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