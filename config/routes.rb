ActionController::Routing::Routes.draw do |map|

  # album & photo routes
  map.resources :albums do |album|
    album.resources :photos, :collection => { :thumb => :get }, :member => { :update_position => :put }
  end
  
  # resftul_authentication routes
  map.resources :users
  map.resource  :session
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password/:id', :controller => 'users', :action => 'reset_password'
  
  # basic top level links
  map.about '/about', :controller => 'main', :action => 'about'
  map.contact '/contact', :controller => 'main', :action => 'contact'
  map.terms '/terms', :controller => 'main', :action => 'terms'
  map.privacy '/privacy', :controller => 'main', :action => 'privacy'
  
  # For google sitemap.xml file
  map.connect "sitemap.xml", :controller => "main", :action => "sitemap"
  
  # root route
  map.root :controller => 'main', :action => 'index'
  
end
