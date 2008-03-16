class RemoveMeaning < ActiveRecord::Migration
  def self.up
    drop_table :meanings
    remove_column :words, :meaning_id
  end

  def self.down
    create_table :meanings do |t|
    end
    add_column :words, :meaning_id, :integer
  end
end
