class PhotosController < ResourceController::Base
  
  belongs_to :album
  
  before_filter :login_required, :only => [:edit, :update]
  skip_before_filter :verify_authenticity_token
  
  create.flash ''
  update.flash 'Photo was successfully updated.'
  destroy.flash 'Photo was successfully removed.'
  
  # redirect to the user album instead of show on update and destroy
  [update, destroy].each { |action| action.wants.html { redirect_to edit_photos_user_album_path(current_user, @album) } }
  
  def create
    # SWFUpload file
    # we have issues using restful_auth methods with SWFUpload, so we can't load the album filtered by current user.
    # TODO - figure out what the deal is
    @album = Album.find(params[:album_id])
    @photo = @album.photos.build(:swfupload_file => params[:Filedata])
    # determine the title based on the filename
    @photo.title = @photo.image_file_name.gsub(/\..*/, '').titleize if @photo.title.blank?
    if @photo.save
      render :text => @photo.image_file_name
    else
      render :text => "error"
    end
  end
  
  # find the latest photo for the album matching the filename
  def thumb
    @album = Album.find(params[:album_id])
    filename = params[:filename]
    @photo = @album.photos.find(:first, :conditions => [ "image_file_name = ?", filename ], :order => 'created_at DESC')
  end
  
  # update an individual photo's position
  def update_position
    @album = current_user.albums.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    @photo.insert_at(params[:position].to_i)
    
    render :text => 'Success'
  end
  
  private
  
    # Defining the collection explicitly for paging / ordering
    def collection
      @collection ||= end_of_association_chain.paginate :page => params[:page], :per_page => 10, :order => 'position'
    end
    
end