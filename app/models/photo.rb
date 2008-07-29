class Photo < ActiveRecord::Base
  
  belongs_to :album, :counter_cache => true
  acts_as_list :scope => :album
  
  has_attachment :content_type => :image, 
                 :storage => :file_system, 
                 :max_size => 500.kilobytes, 
                 :thumbnails => { :thumb  => '100x100>', :album_cover => '180x180', :medium => '300x300', :large => '600x600' }
  
  # Custom validation instead of using attachment_fu validation
  def validate
    errors.add_to_base("You must choose a file to upload") if self.filename.blank?

    unless self.filename.blank?

      # Images should only be GIF, JPEG, or PNG
      # Doesn't seem to work for me
      [:content_type].each do |attr_name|
        enum = attachment_options[attr_name]
        unless enum.nil? || enum.include?(send(attr_name))
          errors.add_to_base("You can only upload images (GIF, JPEG, or PNG)")
        end
      end

      # Images should be less than 500 KB
      [:size].each do |attr_name|
        enum = attachment_options[attr_name]
        unless enum.nil? || enum.include?(send(attr_name))
          errors.add_to_base("Images should be smaller than 500 KB in size")
        end
      end

    end
  end
  
end
