class WelcomeController < ApplicationController 
  before_filter :authenticate_follow_info_user!
  helper_method :sort_column, :sort_direction 
	
	def add_pif 
	  User.add_pif(params)
	  redirect_to(:action => 'list_pif')
	end 
	
  def check_foller_update_status    
    larry = LarrysTwitterAccount.instance 
    @follers_job_id = params[:follers_job_id]        
    if request.xhr?
      @status = larry.foller_update_status(@follers_job_id)
      if @status 
        @pct = @status["num"]   
      else 
        @pct = "UNKNOWN"
      end 
      render :text => @pct
    end
  end 
  
  def check_lists_update_status 
    larry = LarrysTwitterAccount.instance 
    @lists_job_id = params[:lists_job_id]
    if request.xhr? 
      @status = larry.lists_update_status(@lists_job_id)
      if @status 
        @pct = @status["num"]
      else 
        @pct = "UNKNOWN"
      end
      render :text => @pct
    end 
  end 
  	
	def check_pif_update_status
    larry = LarrysTwitterAccount.instance     
    @pifs_job_id = params[:pifs_job_id]        
    if request.xhr?
      @status = larry.pif_update_status(@pifs_job_id)
      if @status 
        @pct = @status["num"]   
      else 
        @pct = "UNKNOWN"
      end 
      render :text => @pct
    end  
  end   
  
  def index 
    @following = User.where(:i_follow => 1).count 
    @followers = User.where(:follows_me => 1).count
  end 
  
  def list_fewer
    @my_followers_count = User.larrys_foller_count    
    sort_clause = "i_follow_nbr DESC"
    @fewer = User.where("i_follow = 1 AND nbr_followers <= ?", @my_followers_count).order(sort_clause) 
    @count = @fewer.size  
    @percent = @count * 100 / User.larry_following_count 
  end 
   
  def list_follers 
    @sort_column_default = 'follows_me_nbr'
    @sort_direction_default = 'desc'
    @follers = User.where(:follows_me => 1).order(sort_column + " " + sort_direction)   
    @count = @follers.size
  end  
  
  def list_idropped       
    sort_clause = "i_follow_nbr DESC"
    @deleted_pifs = DeletedPif.order(sort_clause)   
  end
  
  def list_pif  
    @sort_column_default = 'i_follow_nbr'   
    @sort_direction_default = 'desc'
    @users = User.where(:i_follow => 1).order(sort_column + " " + sort_direction)  
    @count = @users.size 
  end   
  
  def list_stats
    @following = User.larry_following_count 
    @followers = User.larrys_foller_count
    @more = User.where("i_follow = 1 AND nbr_followers > ?", @followers).count
    @less_eq = @following - @more
    @more_pct = @more * 100 / @following
    @less_pct = @less_eq * 100 / @following 
    @median_fol = User.median_followers_of_pif 
    @mean_fol = User.where(:i_follow => 1).average(:nbr_followers)     
  end
  
  def list_unfollowed     
    sort_clause = "fmr_follows_me_nbr DESC"
    @my_quitters = MyQuitter.order(sort_clause)
  end   
  
  def update_follers 
    larry = LarrysTwitterAccount.instance 
    follers_job_id = larry.update_follers
    redirect_to :action => 'check_foller_update_status', :follers_job_id => follers_job_id
  end
  
  def update_lists 
    larry = LarrysTwitterAccount.instance 
    lists_job_id = larry.update_lists 
    redirect_to :action => 'check_lists_update_status', :lists_job_id => lists_job_id
  end 
  
  def update_pif    
    larry = LarrysTwitterAccount.instance 
    pifs_job_id = larry.update_all_pif  
    redirect_to :action => 'check_pif_update_status', :pifs_job_id => pifs_job_id
  end     
    
  private 
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : @sort_column_default
  end
  
  def sort_direction 
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end  
      
end