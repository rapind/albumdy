class MainController < ApplicationController

  caches_page :about, :terms, :privacy, :sitemap
  
  def index
    @albums = Album.find :all, :limit => 2, :conditions => 'visible = 1', :order => 'created_at DESC'
    @photos = Photo.find :all, :limit => 9, :conditions => 'visible = 1 and thumbnail IS NULL', :order => 'created_at DESC'
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
