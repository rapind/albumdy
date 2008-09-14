class MainController < ApplicationController

  #caches_page :sitemap
  
  before_filter :set_feed
  
  def index
    @albums = Album.find :all, :limit => 2, :conditions => 'visible = 1 AND photos_count > 0', :order => 'created_at DESC'
    @photos = Photo.find :all, :limit => 9, :conditions => 'visible = 1', :order => 'created_at DESC'
  end

  def about
  end

  def terms
  end

  def privacy
  end
  
  def sitemap
    @albums = Album.find :all, :conditions => 'visible = 1', :order => 'created_at DESC'
    render :action => 'sitemap.xml.builder', :layout => false
  end
  
end
