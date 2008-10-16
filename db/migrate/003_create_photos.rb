class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.references :album, :null => false
      t.integer :position, :default => 1
      t.string :title, :limit => 128
      t.string :description, :limit => 500
      
      # paperclip attachment fields
      t.string :image_file_name # Original filename
      t.string :image_content_type # Mime type
      t.integer :image_file_size # File size in bytes
      t.datetime :image_updated_at
      t.boolean :image_local, :null => false, :default => true # images are stored locally first then moved to S3
      
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
