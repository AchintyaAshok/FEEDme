# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131006053825) do

  create_table "restaurant_table_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "restaurant_table_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "restaurant_table_users", ["restaurant_table_id"], name: "index_restaurant_table_users_on_restaurant_table_id"
  add_index "restaurant_table_users", ["user_id"], name: "index_restaurant_table_users_on_user_id"

  create_table "restaurant_tables", force: true do |t|
    t.string   "venue_locu_id", null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "table_items", force: true do |t|
    t.integer  "table_id"
    t.string   "item_name"
    t.integer  "quantity"
    t.float    "price"
    t.boolean  "paid"
    t.integer  "paying_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "venmo_user_id"
  end

end
