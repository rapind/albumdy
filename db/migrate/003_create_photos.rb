class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      # can't specify required fields because thumbnails are stored in this same table as child objects
      # (self-referecing parent/child)
      t.references :album
      t.integer :position, :default => 1
      t.string :title, :limit => 255
      t.text :description
      t.boolean :visible, :null => false, :default => true
      
      # paperclip attachment fields
      t.string :image_file_name # Original filename
      t.string :image_content_type # Mime type
      t.integer :image_file_size # File size in bytes
      t.datetime :image_updated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
