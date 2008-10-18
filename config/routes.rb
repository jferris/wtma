ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'sessions', :action => 'new'

  map.resources :users
  map.resource :session
  map.resources :users, :has_one => :password
  map.resources :users, :has_one => :confirmation
  map.resources :passwords
end
