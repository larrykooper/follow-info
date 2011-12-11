FollowInfo::Application.routes.draw do  
  
  devise_for :follow_info_users, :skip => :registrations 

  root :to => "welcome#index" 
  match '/' => 'welcome#index'
  
  devise_scope :follow_info_user do
    match '/follow_info_users/sign_out' => "devise/sessions#destroy"
  end
  resources :users
  match ':controller/:action'
  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
end
