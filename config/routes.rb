FollowInfo::Application.routes.draw do  
  
  devise_for :follow_info_users, :skip => :registrations 

  root :to => "welcome#index" 
  match '/' => 'welcome#index'
  resources :users
  match ':controller/:action'
  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end
