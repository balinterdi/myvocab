class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.column :name, :string, :null => false
      t.column :code, :string, :null => false, :limit => 2
    end
  end

  def self.down
    drop_table :languages
  end
end
