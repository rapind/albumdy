ActionController::Routing::Routes.draw do |map|

  map.resources :albums, :has_many => :photos
  
end
