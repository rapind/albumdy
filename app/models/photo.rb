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
  
  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.image = data
  end  
  
end
