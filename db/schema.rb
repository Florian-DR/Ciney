# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_06_22_130604) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "charges", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.string "kind"
    t.bigint "gite_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gite_id"], name: "index_charges_on_gite_id"
  end

  create_table "days", force: :cascade do |t|
    t.date "date"
    t.bigint "days_of_week_id", null: false
    t.bigint "holiday_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["days_of_week_id"], name: "index_days_on_days_of_week_id"
    t.index ["holiday_id"], name: "index_days_on_holiday_id"
  end

  create_table "days_of_weeks", force: :cascade do |t|
    t.string "status"
    t.float "price"
    t.bigint "gite_id", null: false
    t.bigint "saison_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gite_id"], name: "index_days_of_weeks_on_gite_id"
    t.index ["saison_id"], name: "index_days_of_weeks_on_saison_id"
  end

  create_table "gite_holidays", force: :cascade do |t|
    t.bigint "holiday_id", null: false
    t.bigint "gite_id", null: false
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gite_id"], name: "index_gite_holidays_on_gite_id"
    t.index ["holiday_id"], name: "index_gite_holidays_on_holiday_id"
  end

  create_table "gites", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "capacity"
    t.integer "rooms"
    t.integer "sanitary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "commun"
    t.string "hero_title"
    t.text "hero_description"
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "home_pages", force: :cascade do |t|
    t.string "introduction_title"
    t.text "introduction_text"
    t.string "gites_title"
    t.string "mariages_title"
    t.text "mariages_text"
    t.string "entreprises_title"
    t.string "decouvrir_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "gites_description"
  end

  create_table "saisons", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "charges", "gites"
  add_foreign_key "days", "days_of_weeks"
  add_foreign_key "days", "holidays"
  add_foreign_key "days_of_weeks", "gites"
  add_foreign_key "days_of_weeks", "saisons"
  add_foreign_key "gite_holidays", "gites"
  add_foreign_key "gite_holidays", "holidays"
end
