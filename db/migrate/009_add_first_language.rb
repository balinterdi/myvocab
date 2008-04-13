class AddFirstLanguage < ActiveRecord::Migration
  def self.up
    add_column :users, :first_language_id, :integer, :null => false
  end

  def self.down
    remove_column :users, :first_language_id
  end
end
