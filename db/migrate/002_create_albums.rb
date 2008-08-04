class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.references :user, :null => false
      t.integer :position, :null => false, :default => 1
      t.string :title, :limit => 255, :null => false
      t.text :description
      t.boolean :visible, :null => false, :default => true
      t.integer :photos_count, :null => false, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
