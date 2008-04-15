class RemoveUserFirstLanguage < ActiveRecord::Migration
  def self.up
    remove_column :users, :first_language_id
  end

  def self.down
    add_column :users, :first_language_id, :integer, :null => false
  end
end
