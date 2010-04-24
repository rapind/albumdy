class AddHomePageTitleToAdministrators < ActiveRecord::Migration
  def self.up
    add_column(:administrators, :home_page_title, :string)
  end

  def self.down
    remove_column(:administrators, :home_page_title)
  end
end