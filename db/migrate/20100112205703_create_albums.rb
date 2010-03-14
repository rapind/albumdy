class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.references :administrator, :null => false
      t.integer :position, :null => false, :default => 1
      t.string :title, :null => false, :limit => 100
      t.string :keywords, :limit => 200
      t.text :description, :null => false

      # paperclip attachment fields
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      
      t.string :cached_slug
      
      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
