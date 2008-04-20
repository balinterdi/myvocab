class WordAddLanguage < ActiveRecord::Migration
  def self.up
    add_column :words, :language_id, :integer, :null => false
    remove_column :words, :lang
  end

  def self.down
    add_column :words, :lang, :string, :null => false
    remove_column :words, :language_id
  end
end
