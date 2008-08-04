class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :login, :null => false, :limit => 12
      t.string :email, :null => false, :limit => 128
      t.string :remember_token, :limit => 40
      t.string :crypted_password, :limit => 40
      t.string :password_reset_code, :limit => 40
      t.string :salt, :limit => 40
      t.string :activation_code, :limit => 40
      t.datetime :remember_token_expires_at, :activated_at, :deleted_at
      t.string :state, :null => false, :default => 'passive'
      
      t.string :full_name, :limit => 64
      t.string :web_site_url, :limit => 255
      t.boolean :visible, :null => false, :default => true
      t.integer :albums_count, :null => false, :default => 0
      
      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end