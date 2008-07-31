ActionController::Routing::Routes.draw do |map|

  # management section where user's manage their albums and photos
  map.namespace :manage do |manage|
    manage.resources :users do |user|
      user.resources :albums do |album|
        album.resources :photos, :collection => { :thumb => :get }, :member => { :update_position => :put }
      end
    end
  end
  
  # public view of users, their albums and the photos within
  map.resources :users do |user|
    user.resources :albums do |album|
      album.resources :photos
    end
  end
  
  # public view of albums and the photos within
  map.resources :albums do |album|
    album.resources :photos
  end
  
  # public view of photos
  map.resources :photos
  
  # regsitration and login routes
  map.resource  :session
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login  '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password/:id', :controller => 'users', :action => 'reset_password'
  
  # basic top level routes
  map.about '/about', :controller => 'main', :action => 'about'
  map.contact '/contact', :controller => 'main', :action => 'contact'
  map.terms '/terms', :controller => 'main', :action => 'terms'
  map.privacy '/privacy', :controller => 'main', :action => 'privacy'
  
  # google sitemap route
  map.connect "sitemap.xml", :controller => "main", :action => "sitemap"
  
  # root route
  map.root :controller => 'main', :action => 'index'
  
end
