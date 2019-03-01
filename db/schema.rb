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

ActiveRecord::Schema.define(version: 2019_03_01_163954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.text "description", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.decimal "cost", precision: 10, scale: 2, null: false
    t.string "handle", limit: 255, null: false
    t.datetime "published_at"
    t.integer "inventory", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["handle", "owner_id"], name: "index_products_on_handle_and_owner_id", unique: true
    t.index ["owner_id"], name: "index_products_on_owner_id"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.boolean "email_verified", default: false
    t.string "verification_digest"
    t.datetime "verified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_subscribers_on_email", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "phone", limit: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "phone_verified", default: false
    t.string "remember_digest"
    t.index ["phone"], name: "index_users_on_phone", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "products", "users", column: "owner_id"
end
