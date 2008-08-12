class Manage::Albums::PhotosController < ApplicationController

  # SWFUpload has issues with login_required
  before_filter :login_required, :except => :create
  before_filter :find_album, :except => :create
  
  def index
    @photos = @album.photos.paginate :all, :page => params[:page]
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @photos }
    end
  end
  
  def show
    @photo = @album.photos.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @photo }
    end
  end
  
  def new
    @photo = @album.photos.build
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @photo }
    end
  end
  
  def edit
    @photo = @album.photos.find(params[:id])
  end
  
  def create
    
    if params[:Filedata]
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
    else
      # Standard upload
      @photo = @album.photos.build params[:photo]
      # determine the title based on the filename
      @photo.title = @photo.image_file_name.gsub(/\..*/, '').titleize if @photo.title.blank?
      if @photo.save
        flash[:notice] = 'Your photo has been uploaded!'
        redirect_to photos_path
      else
        render :action => :new
      end
    end
    
  end
  
  def update
    @photo = @album.photos.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo successfully updated.'
        format.html { redirect_to manage_album_path(@album) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @photo = @album.photos.find(params[:id])
    @photo.destroy

    respond_to do |format|
      flash[:notice] = 'Photo successfully removed.'
      format.html { redirect_to manage_album_path(@album) }
      format.xml  { head :ok }
    end
  end
  
  
  # find the latest photo for the album matching the filename
  def thumb
    filename = params[:filename]
    @photo = @album.photos.find(:first, :conditions => [ "image_file_name = ?", filename ], :order => 'created_at DESC')
  end
  
  
  # update an individual photo's position
  def update_position
    @photo = @album.photos.find(params[:id])
    @photo.insert_at(params[:position].to_i)
    
    render :text => 'Success'
  end
  
  private #-----------------
  
  def find_album
    @album = current_user.albums.find(params[:album_id])
  end
  
end