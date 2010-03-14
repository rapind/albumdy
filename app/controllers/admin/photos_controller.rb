class Admin::PhotosController < Admin::HomeController
  inherit_resources
  belongs_to :album
  actions :all
  respond_to :html
  before_filter :reset_token_for_uploadify, :only => :index
  before_filter :require_ownership, :except => [:flash_upload]
  
  # we need to turn off the admin and auth check for now, because the flash plugin isn't passing this information along,
  #  and because the alternatives are waaaay too complicated right now. TODO - look into this again down the road.
  # see: http://thewebfellas.com/blog/2008/12/22/flash-uploaders-rails-cookie-based-sessions-and-csrf-rack-middleware-to-the-rescue
  skip_before_filter :require_administrator, :verify_authenticity_token, :only => :flash_upload
  # instead we're going to generate our own random token, save it to the administrator, then pass it in the flash uploader's params.
  # Finally we'll verify it before accepting a flash upload
  
  # redirect to collection path on create instead of show
  def create
    create!{ collection_path }
  end
  
  # redirect to collection path on update instead of show
  def update
    update!{ collection_path }
  end
  
  def destroy
    destroy! do |success, failure|
      success.js { 
        flash[:notice] = ''
        render :json => {:title => 'Success', :message => 'Photo was successfuly removed.'} 
      }
      failure.js { render :json => {:title => 'Error', :message => 'Ran into an error removing the photo. Please try again later.'} }
    end
  end
  
  def flash_upload
    # validate the perishable_token param
    if params[:perishable_token]
      # find the administrator by perishable_token
      @administrator = Administrator.find_using_perishable_token(params[:perishable_token])
      album = @administrator.albums.find(params[:album_id])
      photo = album.photos.new(params[:photo])
      # need to assign the correct content type becuase this is missing from a flash upload
      photo.image_content_type = MIME::Types.type_for(photo.image_file_name).to_s
      if photo.save
        render :json => {:title => 'Success', :message => 'Photo was successfuly created.', :id => photo.id}
      else
        logger.debug "#{photo.errors.inspect}"
        render :json => {:title => 'Error', :message => 'Ran into a problem uploading your photo.'}
      end
    else
      logger.error "Invalid token: #{params[:perishable_token]}"
      render :json => {:title => 'Error', :message => 'Ran into a security problem uploading your photo.'}, :layout => nil
    end
  end
  
  # update an individual album photo's position
  def update_position
    begin
      photo = @album.photos.find(params[:id]) # grab the object
      photo.insert_at(params[:position].to_i) # update the object's order
      render :json => {:title => 'Success', :message => 'The order was updated successfuly.'}
    rescue
      logger.error $ERROR_INFO.inspect
      render :json => {:title => 'Error', :message => 'Ran into an error updating the order. Please try again.'}
    end
  end
    
    
  private #-----
  
    # make sure the administrator owns the album / photos they are trying to access
    def require_ownership
      @album = Album.find(params[:album_id])
      if current_administrator.id == @album.administrator.id
        return true
      else
        # doesn't own the parent booking
        flash[:warning] = 'You can only manage albums and photos associated with your account.'
        redirect_to admin_albums_path # back to the albums they DO own
        return false
      end
    end
  
    # reset the administrator's perishable token for uploadify authentication
    def reset_token_for_uploadify
      @config.reset_perishable_token!
    end
    
end
