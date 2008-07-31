class Manage::Users::Albums::PhotosController < ResourceController::Base

  belongs_to :album
  
  # SWFUpload has issues with login_required
  before_filter :login_required, :except => :create
  
  # redirect to the parent object
  [update, destroy].each { |action| action.wants.html { redirect_to manage_user_album_path(current_user, parent_object) } }
  
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
  
  
  # update an individual photo's position
  def update_position
    @photo = parent_object.photos.find(params[:id])
    @photo.insert_at(params[:position].to_i)
    
    #delta = params[:delta].to_i
    #logger.info("Photo #{@photo.id}, delta: #{delta}")
    
    #@photo.position = params[:position].to_i
    #if @photo.save!
      render :text => 'Success'
    #else
    #  render :text => 'Error'
    #end
  end
  
end