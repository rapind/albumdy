ActionController::Routing::Routes.draw do |map|
  # root
  map.root :controller => 'home'
  map.config_error '/config_error', :controller => 'home', :action => 'config_error'
  map.not_found '/not_found', :controller => 'home', :action => 'not_found'
  
  # sitemap
  map.resources :sitemap
  
  # albums
  map.resources :albums, :member => { :slide => :get }, :has_many => :photos
  
  # administration area
  map.admin '/admin', :controller => 'admin/albums'
  map.namespace :admin do |admin|
    # session / login / logout
    admin.resource :administrator_session
    admin.login '/login', :controller => "administrator_sessions", :action => "new"
    admin.logout '/logout', :controller => "administrator_sessions", :action => "destroy"
    admin.resource :administrator
    admin.resources :administrator_password_resets
    admin.resources :albums, :member => { :update_position => :put } do |album|
      album.resources :photos, :member => { :update_position => :put }, :collection => { :flash_upload => :post }
    end
    admin.resources :photo
  end
end
