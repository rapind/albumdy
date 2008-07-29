class PhotosController < ResourceController::Base

  belongs_to :album
  
  # redirect to the parent object
  [update, destroy].each { |action| action.wants.html { redirect_to album_path(parent_object) } }
  
  update.flash 'Photo successfully updated.'
  destroy.flash 'Photo successfully removed.'
  
  def create
    # build the photo within the parent_object (album)    
    @photo = parent_object.photos.build(:uploaded_data => params[:Filedata])
    logger.info(parent_object.title)
    # fix the content type
    @photo.content_type = MIME::Types.type_for(@photo.filename).to_s
    
    # determine the title based on the filename
    @photo.title = @photo.filename.gsub(/\..*/, '').titleize if @photo.title.blank?
    
    # save it
    @photo.save!
    
    # send back filename
    render :text => @photo.public_filename
  end
  
  # find the latest photo for the album matching the filename
  def thumb
    filename = params[:filename]
    logger.info(filename)
    @photo = object = parent_object.photos.find(:first, :conditions => [ "filename = ?", filename ], :order => 'created_at DESC')
    logger.info(object.title)
  end
  
  
  def update_order
    @photo = object = parent_object.photos.find(params[:id])
    @photo.position = params[:position]
    @photo.save
  end
  
  
end