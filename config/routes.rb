FollowInfo::Application.routes.draw do  
  
  devise_for :follow_info_users
  #devise_for :follow_info_users, :skip => :registrations 

  root :to => "welcome#index" 
  match '/' => 'welcome#index'
  match "tags" => "tag#list"
  get "/welcome/index"
  get "/welcome/list_pif"
  get "/welcome/list_stats"
  get "/welcome/list_follers"
  get "/welcome/list_unfollowed"
  get "/welcome/list_idropped"
  get "/welcome/check_pif_update_status"
  get "/welcome/check_foller_update_status"
  get "/tag/edit"
  post "/tag/edit"
  post "/welcome/update_follers"
  post "/welcome/update_pif"
  
  devise_scope :follow_info_user do
    match '/follow_info_users/sign_out' => "devise/sessions#destroy"
  end
  resources :users
  
  #match ':controller/:action'
  #match ':controller/:action/:id'
  #match ':controller/:action/:id.:format'
end
