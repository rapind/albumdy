class AddPhotoMetadata < ActiveRecord::Migration
  def self.up
    add_column :photos, :camera_model, :string, :limit => 128
    add_column :photos, :exposure_time, :string, :limit => 10
    add_column :photos, :f_number, :string, :limit => 5
    add_column :photos, :taken_at, :datetime
  end

  def self.down
    remove_column :photos, :camera_model
    remove_column :photos, :exposure_time
    remove_column :photos, :f_number
    remove_column :photos, :taken_at
  end
end
