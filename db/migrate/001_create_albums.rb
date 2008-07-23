class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :title, :limit => 255, :null => false
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
