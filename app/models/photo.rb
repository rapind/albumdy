class Photo < ActiveRecord::Base
  belongs_to :album
  
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 500.kilobytes, 
                 :resize_to => '800x600>', 
                 :thumbnails => { 
                   :thumb  => '100x100>',  
                   :large  => '450x600>', 
                   :medium => '64x64', 
                   :small  => '48x48' 
                 } 

  validates_as_attachment
  
end
