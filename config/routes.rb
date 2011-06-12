FollowInfo::Application.routes.draw do  
 
  match '/' => 'welcome#index'
  resources :users
  match ':controller/:action'
  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end
