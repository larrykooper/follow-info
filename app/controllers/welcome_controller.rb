class WelcomeController < ApplicationController
  before_action :authenticate_follow_info_user!
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
    @following = User.where(:i_follow => true).count
    @followers = User.where(:follows_me => true).count
  end

  # sort_column and sort_direction are helper methods defined
  #  in this controller
  #  t.name is tag name
  #  When listing by tags, I want to sort by i_follow_nbr
  def list_pif
    if params[:chosen_letter]
      @users = User.pifs_alpha_nav(
        params[:chosen_letter]
      )
    else
      per_page = 50
      @sort = sort_column
      @direction = sort_direction
      if @sort == 'LOWER(t.name)'
        two_sorts = true
        second_sort = 'i_follow_nbr'
        second_direction = 'desc'
      else
        two_sorts = false
        second_sort = ''
        second_direction = ''
      end
      @count = User.larry_following_count
      @page_wanted = params[:page] ||= 1
      @total_pages = (@count / per_page) + 1
      # calls User model to get the PIFs to display
      @users = User.pifs_general_case(
        per_page,
        @page_wanted,
        @sort,
        @direction,
        two_sorts,
        second_sort,
        second_direction
      )
    end
    @users
    # should just return 50 users unless nav is by alpha
  end

  def list_follers
    @sort_column_default = 'follows_me_nbr'
    @sort_direction_default = 'desc'
    @follers = User.where(:follows_me => true).order(sort_column + " " + sort_direction)
    @count = @follers.size
  end

  def list_idropped
    sort_clause = "i_follow_nbr DESC"
    @deleted_pifs = DeletedPif.order(sort_clause)
  end

  def list_stats
    @following = User.larry_following_count
    @followers = User.larrys_foller_count
    @pif_folling = User.pif_following_me_count
    @pif_folling_pct = @pif_folling * 100 / @following
    @median_fol = User.median_followers_of_pif
    @mean_fol = User.where(:i_follow => true).average(:nbr_followers)
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

  def update_pif
    larry = LarrysTwitterAccount.instance
    pifs_job_id = larry.update_all_pif
    redirect_to :action => 'check_pif_update_status', :pifs_job_id => pifs_job_id
  end

  private

  # Default sort column is i_follow_nbr
  def sort_column
    if !params[:sort]
      "i_follow_nbr"
    elsif params[:sort] == 'tag'
      "LOWER(t.name)"
    else
      params[:sort]
    end
  end

  # Default sort direction is descending
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end