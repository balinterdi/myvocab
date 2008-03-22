class MakePasswordHashed < ActiveRecord::Migration
  def self.up
    rename_column :users, :password, :hashed_password
    change_column :users, :hashed_password, :string # no limit on length
    add_column :users, :salt, :string
  end

  def self.down
    rename_column :users, :hashed_password, :password
    remove_column :users, :salt
  end
end
