class ReaddMeaningAsHasManyThrough < ActiveRecord::Migration
  def self.up
    create_table :meanings do |t|
      t.column :word_id, :integer
      t.column :synonym_word_id, :integer
    end
  end

  def self.down
    drop_table :meanings
  end
end
