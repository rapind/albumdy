class Photo < ActiveRecord::Base
  
  belongs_to :album, :counter_cache => true
  acts_as_list :scope => :album
  
  has_attached_file :image, :styles => { :medium => "300x300>", :album_cover => '180x180>', :thumb => "100x100>" }
  
  # Fix the mime types. Make sure to require the mime-types gem
  def swfupload_file=(data)
    data.content_type = MIME::Types.type_for(data.original_filename).to_s
    self.image = data
  end

end
