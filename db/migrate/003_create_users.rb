class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :name, :string
      t.column :login, :string, :limit => 30, :null => false
      t.column :password, :string, :limit => 30, :null => false
      t.column :email, :string, :limit => 30, :null => false
    end
  end

  def self.down
    drop_table :users
  end
end
