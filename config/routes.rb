ActionController::Routing::Routes.draw do |map|

  # albums
  map.resources :albums, :has_many => :photos
  
  # users
  map.resources :users do |user|
    # displaying and managing photos for users
    user.resources :albums, :member => { :edit_photos => :get } do |album|
      album.resources :photos, :collection => { :thumb => :get }, :member => { :update_position => :put }
    end
  end
  
  # admin section to manage all users, albums, and photos.
  # simple management operations means we don't need deeply nested routes.
  map.namespace :admin do |admin|
    admin.resources :users, :has_many => :albums
    admin.resources :albums, :has_many => :photos
    admin.resources :photos
  end
  
  # regsitration and login routes
  map.resource  :session
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password/:id', :controller => 'users', :action => 'reset_password'
  
  # basic top level routes
  map.root :controller => 'main', :action => 'index'
  map.about '/about', :controller => 'main', :action => 'about'
  map.contact '/contact', :controller => 'main', :action => 'contact'
  map.terms '/terms', :controller => 'main', :action => 'terms'
  map.privacy '/privacy', :controller => 'main', :action => 'privacy'
  map.connect "sitemap.xml", :controller => "main", :action => "sitemap" # google sitemap.xml
  
end
