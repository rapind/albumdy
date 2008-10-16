class AlbumsController < ResourceController::Base

  belongs_to :user
  
  before_filter :login_required, :only => [:new, :create, :edit, :update, :edit_photos, :destroy]
  
  create.flash "Your album has been created successfully."
  update.flash "Your album has been updated successfully."
  
  index.wants.xml { render :xml => @albums }
  show.wants.xml { render :xml => @album }
  index.wants.rss  { render :layout => false } # uses index.rss.builder

  # redirect to edit instead of show on create and update
  [create, update].each { |action| action.wants.html { redirect_to edit_photos_user_album_path(@object.user, @object) } }
  
  show.wants.html {
    render(:layout => 'album')
  }
  edit.wants.html {
    @page_title = "Editing #{@object.title}"
    @page_description = "Choose a title for your album of up to 40 characters, and a description of up to 500 characters."
  }
  
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
    @feed_url = formatted_albums_url(:rss)
  end
  
  private

    # Defining the collection explicitly for paging / ordering
    def collection
      # TODO - add conitional conditions for empty albums
      @collection ||= end_of_association_chain.paginate  :page => params[:page], :per_page => 10, :order => 'created_at DESC'
    end
  
end
