class Admin::AlbumsController < Admin::HomeController
  inherit_resources
  actions :all, :except => :show
  respond_to :html
  
  # check ownership and redirect to collection path on create instead of show
  def create
    @album = current_administrator.albums.new(params[:album])
    create!{ collection_path }
  end
  
  # check ownership and redirect to collection path on update instead of show
  def update
    @album = current_administrator.albums.find(params[:id])
    update!{ collection_path }
  end
  
  # check ownership
  def destroy
    @album = current_administrator.albums.find(params[:id])
    destroy! do |success, failure|
      success.js { 
        flash[:notice] = ''
        render :json => {:title => 'Success', :message => 'Album was successfuly removed.'} 
      }
      failure.js { render :json => {:title => 'Error', :message => 'Ran into an error removing the album. Please try again later.'} }
    end
  end
  
  # check ownership and update an individual album's position
  def update_position
    begin
      album = current_administrator.albums.find(params[:id])
      album.insert_at(params[:position].to_i) # update the object's order
      render :json => {:title => 'Success', :message => 'The order was updated successfuly.'}
    rescue
      render :json => {:title => 'Error', :message => 'Ran into an error updating the order. Please try again.'}
    end
  end
  
  private #-------
    # Defining the collection explicitly for ordering
    def collection
      @albums ||= current_administrator.albums.find :all
    end
    
end
