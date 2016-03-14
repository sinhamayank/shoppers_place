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

ActiveRecord::Schema.define(version: 20160313180638) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "category_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["category_name"], name: "index_categories_on_category_name", unique: true, using: :btree

  create_table "category_and_product_relationships", force: true do |t|
    t.integer  "product_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.integer  "product_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.date     "expire_date"
    t.integer  "sku_id"
    t.integer  "price"
    t.integer  "array_of_tag_ids",      default: [], array: true
    t.integer  "array_of_category_ids", default: [], array: true
    t.string   "prod_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["prod_id"], name: "index_products_on_prod_id", unique: true, using: :btree

  create_table "tag_and_product_relationships", force: true do |t|
    t.integer  "tag_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string   "tag_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["tag_name"], name: "index_tags_on_tag_name", unique: true, using: :btree

end
