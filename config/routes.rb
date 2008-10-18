ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'sessions', :action => 'new'

  map.openid '/openid', :controller => 'openid', :action => 'create'

  map.new_purchase '/purchases/new', :controller => 'sessions', :action => 'new' ### Just for testing redirects

  map.resources :items
  map.resources :users
  map.resource :session
  map.resources :users, :has_one => :password
  map.resources :users, :has_one => :confirmation
  map.resources :passwords
  map.resources :stores
end
