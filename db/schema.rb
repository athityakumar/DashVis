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

ActiveRecord::Schema.define(version: 20171220053104) do

  create_table "charts", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.string "category_column"
    t.string "weight_column"
    t.integer "table_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_charts_on_table_id"
  end

  create_table "collection_tables", force: :cascade do |t|
    t.integer "collection_id"
    t.integer "table_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_collection_tables_on_collection_id"
    t.index ["table_id"], name: "index_collection_tables_on_table_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "columns", force: :cascade do |t|
    t.string "name"
    t.string "datatype"
    t.integer "table_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_columns_on_table_id"
  end

  create_table "data", force: :cascade do |t|
    t.string "value"
    t.integer "row_id"
    t.integer "column_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["column_id"], name: "index_data_on_column_id"
    t.index ["row_id"], name: "index_data_on_row_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.string "color_scheme"
    t.string "provider"
    t.string "uid"
    t.string "image"
    t.string "oauth_token"
    t.datetime "oauth_expires_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "rows", force: :cascade do |t|
    t.integer "table_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id"], name: "index_rows_on_table_id"
  end

  create_table "tables", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tables_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.string "email"
    t.string "color_scheme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
