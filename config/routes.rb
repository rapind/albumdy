ActionController::Routing::Routes.draw do |map|

  map.resources :albums do |album|
    album.resources :photos, :collection => { :thumb => :get }, :member => { :update_order => :put }
  end
  
  map.root :controller => 'main', :action => 'index'
  
end
