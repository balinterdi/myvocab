class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words do |t|
      t.column :name, :string, :null => false
      t.column :lang, :string, :null => false, :limit => 2
      t.column :meaning_id, :integer
    end
  end

  def self.down
    drop_table :words
  end
end
