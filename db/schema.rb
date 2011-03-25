# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110325123247) do

  create_table "hitchhikes", :force => true do |t|
    t.string   "title"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.string   "photo_file_size"
    t.string   "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "story"
    t.integer  "waiting_time"
    t.integer  "trip_id"
    t.float    "duration"
  end

  add_index "hitchhikes", ["photo_file_name"], :name => "index_hitchhikes_on_photo_file_name"

  create_table "people", :force => true do |t|
    t.string  "name"
    t.string  "occupation"
    t.string  "mission"
    t.string  "origin"
    t.integer "hitchhike_id"
    t.integer "age"
    t.string  "gender"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories_on_item_and_table_and_month_and_year"

  create_table "trips", :force => true do |t|
    t.integer  "distance"
    t.datetime "start"
    t.integer  "duration"
    t.string   "from"
    t.string   "to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "from_country"
    t.string   "to_country"
    t.string   "formatted_from"
    t.string   "formatted_to"
    t.string   "from_city"
    t.string   "to_city"
    t.integer  "money_spent"
    t.integer  "travelling_with"
    t.datetime "end"
  end

  add_index "trips", ["from_country"], :name => "index_trips_on_from_country"
  add_index "trips", ["to_country"], :name => "index_trips_on_to_country"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username"

end
