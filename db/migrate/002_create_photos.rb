class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :title, :limit => 255, :null => false
      
      #Image upload related fields
      t.integer :parent_id, :size, :width, :height
      t.string :content_type, :filename, :thumbnail
      
      t.references :album, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
