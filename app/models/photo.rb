class Photo < ActiveRecord::Base
  
  belongs_to :album, :counter_cache => true
  acts_as_list :scope => :album
  
  validates_presence_of :album
  validates_length_of :title, :within => 5..128, :allow_nil => true, :allow_blank => true
  validates_length_of :description, :within => 20..500, :allow_nil => true, :allow_blank => true
  
  has_attached_file :image, 
                    # 2:3 ratio used in most cameras (1.5), plus some common monitor resolutions for wallpapers
                    :styles => { :wuxga => '1920x1200', :uxga => '1600x1200', :wsxga => '1440x900', :sxga => '1400x1050', :xga => '1024x768', :svga => '800x600', :vga => "640x480", :original => "700x466", :cover => "150x100!", :thumb => "68x50!" },
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
