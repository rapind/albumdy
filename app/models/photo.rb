class Photo < ActiveRecord::Base
  
  belongs_to :album, :counter_cache => true
  acts_as_list :scope => :album
  
  validates_presence_of :album
  validates_length_of :title, :within => 5..128, :allow_nil => true, :allow_blank => true
  
  has_attached_file :image,
                    # using typical SLR camera aspect ratio of 2:3 (I.e. 4" x 6")
                    :styles => { :original => "700x466", :cover => "150x100!", :thumb => "68x50!" },
                    :path => ":rails_root/public/photos/:id/:style_:basename.:extension",
                    :url => "/photos/:id/:style_:basename.:extension"
                    #:storage => :s3,
                    #:s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
                    #:path => "photos/:id/:style_:basename.:extension",
                    #:bucket => 'albumdy'
                    
  validates_attachment_presence :image
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/gif', 'image/png', 'image/pjpeg', 'image/x-png'] 
  
  # This is the datetime format EXIF datetime is represented in 
  @@exif_date_format = '%Y:%m:%d %H:%M:%S'
  
  # Define Paperclip callback just for the Photo attachment 
  after_image_post_process  :post_process_image
  
  # Callback after styles processing (thumbnails). 
  # Use this to extract Exif metadata from the image
  def post_process_image
    # only works with jpgs
    if image.content_type == 'image/jpeg' || 'image/pjpeg'
      img_meta = EXIFR::JPEG.new(image.queued_for_write[:original].path)
      return unless img_meta
      logger.debug "Photo EXIF: " + img_meta.inspect
      self.camera_model = img_meta.model
      self.exposure_time = img_meta.exposure_time.to_s
      self.f_number = img_meta.f_number.to_s
      self.taken_at = img_meta.date_time
      # also have width and height. See http://exifr.rubyforge.org/api/index.html for details
    end
  end
    
end
