class AddDefaultLanguage < ActiveRecord::Migration
  def self.up
    add_column :users, :default_language_id, :integer
  end

  def self.down
    remove_column :users, :default_language_id
  end
end
