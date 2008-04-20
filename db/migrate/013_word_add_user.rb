class WordAddUser < ActiveRecord::Migration
  def self.up
    add_column :words, :user_id, :integer, :null => false
  end

  def self.down
    remove_column :words, :user_id
  end
end
