class WelcomeController < ApplicationController 
  
  helper :sort
	include SortHelper
  
  def index 
  end 
   
  def list_follers
    sort_init('follows_me_nbr', 'desc', nil)
    sort_update('')    
    @follers = User.find(:all, :conditions => ["follows_me = 1"], :order => sort_clause) 
  end  
  
  def list_pif 
    sort_init('i_follow_nbr', 'desc', nil) 
    sort_update('')
    @users = User.find(:all, :conditions => ["i_follow = 1"], :order => sort_clause)
  end 
  
  def list_stats
    @following = User.count "i_follow = 1"
    @followers = User.count "follows_me = 1"
    @more = User.count(:conditions => ["i_follow = 1 AND nbr_followers > ?", @followers])
    @less_eq = @following - @more
    @more_pct = @more * 100 / @following
    @less_pct = @less_eq * 100 / @following 
    @median_fol = User.median_followers_of_pif 
    @mean_fol = User.average :nbr_followers, :conditions => "i_follow = 1"    
  end
  
  def update_pif    
    larry = Larry.instance 
    larry.update_all_pif  
    redirect_to(:action => 'check_pif_update_status')
  end  
  
  def check_pif_update_status
    larry = Larry.instance
    @percent_complete = Larry.pif_update_status     
    
    if request.xhr?
      if @percent_complete == 100
        render :update do |page| 
          flash[:notice] = "PIF Update is complete!"
          session[:update_worker_key] = nil
          page.redirect_to :action => "list_pif" 
        end
        larry.finish_update_pifs
      else
        render :update do |page|
          page[:pif_update_status].setStyle :width => "#{@percent_complete * 2}px"
          page[:pif_update_status].replace_html "#{@percent_complete}%"
        end        
      end
    end
  end   
  
  def update_follers 
    larry = Larry.instance 
    larry.update_follers 
    redirect_to(:action => 'check_foller_update_status')     
  end 
  
  def check_foller_update_status
    larry = Larry.instance
    @percent_complete = Larry.foller_update_status     
    
    if request.xhr?
      if @percent_complete == 100     
        render :update do |page| 
          flash[:notice] = "Follower Update is complete!"  
          session[:follower_update_worker_key] = nil
          page.redirect_to :action => "list_follers"   
        end
        larry.finish_update_follers   
      else
        render :update do |page|
          page[:foller_update_status].setStyle :width => "#{@percent_complete * 2}px"
          page[:foller_update_status].replace_html "#{@percent_complete}%"
        end        
      end
    end
  end 
      
end