class AlbumsController < ResourceController::Base

  belongs_to :user
  
  before_filter :login_required, :only => [:new, :create, :edit, :update, :edit_photos, :destroy]
  
  def edit_photos
    @user = current_user
    @album = @object = current_user.albums.find(params[:id])
    
    @page_title = "Editing #{@object.title}"
    @page_description = "From here you can upload new photos, edit existing photos, remove photos, and order their placement."
  end
  
  def set_meta
    @page_title = parent_object ? "Albums from #{parent_object.login}" : 'Shared Albums'
    @page_description = "Select an album below to view it's photos."
    @page_keywords = 'album, photo, gallery, ruby, rails, ruby on rails, open source, blueprint, jquery, lightbox, thickbox, resource_controller, attachment_fu, restful_authentication, braid, github'
    @feed_title = 'Albumdy Photo Albums'
    @feed_url = albums_url(:rss)
  end
  
  create.flash "Your album has been created successfully."
  update.flash "Your album has been updated successfully."

  # redirect to edit instead of show on create and update
  [create, update].each { |action| action.wants.html { redirect_to edit_photos_user_album_path(@object.user, @object) } }
  
  show.wants.html {
    @page_title = "#{@object.title} by #{@object.user.login}"
    render(:layout => 'album')
  }
  edit.wants.html {
    @page_title = "Editing #{@object.title}"
    @page_description = "Choose a title for your album of up to 40 characters, and a description of up to 500 characters."
  }
  
  #index.wants.xml { render :xml => @albums }
  #show.wants.xml { render :xml => @album }
  index.wants.rss  { render :layout => false } # uses index.rss.builder
  
  private

    # Defining the collection explicitly for paging / ordering
    def collection
      # show empty albums only if it's a user looking at their own albums (so they can manage them)
      if parent_object and logged_in? and parent_object.id == current_user.id
        @collection ||= end_of_association_chain.paginate :page => params[:page], :per_page => 4, :order => 'created_at DESC'
      else
        @collection ||= end_of_association_chain.paginate :page => params[:page], :conditions => 'photos_count > 0', :per_page => 4, :order => 'created_at DESC'
      end
    end
  
end
