class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      # can't specify required fields because thumbnails are stored in this same table as child objects
      # (self-referecing parent/child)
      t.references :album
      t.integer :position, :default => 0
      t.string :title, :limit => 255
      t.text :description
      
      # attachment_fu fields
      t.integer :parent_id, :size, :width, :height
      t.string :content_type, :filename, :thumbnail
      
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
