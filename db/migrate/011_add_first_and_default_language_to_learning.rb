# "default language" is considered the mother tongue of the user
# "first language" is the one he is actually studying (a user can learn several languages at a time, but can only have one first language at any given point)
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
