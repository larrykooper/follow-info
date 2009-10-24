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
    @more_pct = @more / @following
    @less_pct = @less_eq / @following 
    @median_fol = User.median_followers_of_pif 
    @mean_fol = User.average :nbr_followers, :conditions => "i_follow = 1"    
  end
  
  def update_pif
    larry = Larry.instance 
    larry.update_all_pif 
    redirect_to(:action => 'list_pif')
  end 
  
  def update_chunk
    lkhere 
  end 
      
end