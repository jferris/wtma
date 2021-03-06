ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'items', :action => 'index'

  map.openid '/openid', :controller => 'openid', :action => 'create'

  map.new_purchase '/purchases/new', :controller => 'sessions', :action => 'new' ### Just for testing redirects

  map.resources :items
  map.resources :users
  map.resource :session
  map.resources :users, :has_one => :password
  map.resources :users, :has_one => :confirmation
  map.resources :passwords
  map.resources :stores
  map.resources :purchases, :collection => {:autocomplete_purchase_quantity => :get, :autocomplete_purchase_item_name => :get} do |purchases|
    purchases.resources :stores, :controller => 'purchases/stores'
  end
end
