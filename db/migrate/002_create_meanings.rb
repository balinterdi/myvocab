class CreateMeanings < ActiveRecord::Migration
  def self.up
    create_table :meanings do |t|
    end
  end

  def self.down
    drop_table :meanings
  end
end
