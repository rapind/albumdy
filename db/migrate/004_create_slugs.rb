class CreateSlugs < ActiveRecord::Migration
  def self.up
    create_table :slugs do |t|
      t.string :name, :limit => 255, :null => false
      t.string :sluggable_type, :limit => 128, :null => false
      t.integer :sluggable_id, :null => false
      t.timestamps
    end
    
    #add_index :slugs, [:name, :sluggable_type], :unique => true
    add_index :slugs, :name
    add_index :slugs, :sluggable_type
    add_index :slugs, :sluggable_id
  end

  def self.down
    drop_table :slugs
  end
end
