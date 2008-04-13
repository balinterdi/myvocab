class CreateLearnings < ActiveRecord::Migration
  def self.up
    create_table :learnings do |t|
      t.column :user_id, :integer
      t.column :language_id, :integer
      t.column :start_date, :date, :null => false
    end
  end

  def self.down
    drop_table :learnings
  end
end
