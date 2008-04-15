class AddFirstAndDefaultLanguageToLearning < ActiveRecord::Migration
  def self.up
    add_column :learnings, :is_first_language, :boolean, :null => false, :default => false
    add_column :learnings, :is_default_language, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :learnings, :is_first_language
    remove_column :learnings, :is_default_language
  end
end
