# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 11) do

  create_table "languages", :force => true do |t|
    t.string "name",              :null => false
    t.string "code", :limit => 2, :null => false
  end

  create_table "learnings", :force => true do |t|
    t.integer "user_id"
    t.integer "language_id"
    t.date    "start_date",                             :null => false
    t.boolean "is_first_language",   :default => false, :null => false
    t.boolean "is_default_language", :default => false, :null => false
  end

  create_table "meanings", :force => true do |t|
    t.integer "word_id"
    t.integer "synonym_word_id"
  end

  create_table "users", :force => true do |t|
    t.string "name"
    t.string "login",           :limit => 30, :null => false
    t.string "hashed_password",               :null => false
    t.string "email",           :limit => 30, :null => false
    t.string "salt"
  end

  create_table "words", :force => true do |t|
    t.string "name",              :null => false
    t.string "lang", :limit => 2, :null => false
  end

end
