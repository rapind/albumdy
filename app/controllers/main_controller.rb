class MainController < ApplicationController

  #caches_page :sitemap
  
  def index
    redirect_to user_albums_path(current_user) if logged_in?
    @albums = Album.find :all, :limit => 2, :conditions => 'visible = 1 AND photos_count > 0', :order => 'created_at DESC'
    @photos = Photo.find :all, :limit => 9, :conditions => 'visible = 1', :order => 'created_at DESC'
  end

  def about
    @page_title = "What is Albumdy?"
    @page_description = "Albumdy was built using: Ruby on Rails, jQuery, Blueprint CSS, Lightbox, Galleria, Thickbox, Resource Controller, Paperclip, Restful Authentication, Amazon S3."
  end

  def terms
    @page_title = "Terms of Use"
    @page_description = "Feel free to use this code and application however you see fit."
  end

  def privacy
    @page_title = "Privacy Policy"
    @page_description = "Best practices have been followed to ensure your data remains private (salt + hash). However, use at your own risk."
  end
  
  def sitemap
    @albums = Album.find :all, :conditions => 'visible = 1', :order => 'created_at DESC'
    render :action => 'sitemap.xml.builder', :layout => false
  end
  
end
