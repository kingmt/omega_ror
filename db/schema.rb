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

ActiveRecord::Schema.define(version: 20170321111417) do

  create_table "past_price_records", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "price"
    t.float    "percentage_change"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["product_id"], name: "index_past_price_records_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer  "external_product_id"
    t.integer  "price"
    t.string   "product_name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

end
