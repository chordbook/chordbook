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

ActiveRecord::Schema.define(version: 2022_01_12_030812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "albums", force: :cascade do |t|
    t.string "title"
    t.json "metadata"
    t.bigint "artist_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "released"
    t.decimal "score", precision: 3, scale: 1
    t.index ["artist_id"], name: "index_albums_on_artist_id"
  end

  create_table "artist_works", force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.string "work_type", null: false
    t.bigint "work_id", null: false
    t.integer "order"
    t.index ["artist_id", "work_id", "work_type", "order"], name: "uniq_by_artist_and_work", unique: true
    t.index ["artist_id"], name: "index_artist_works_on_artist_id"
    t.index ["work_type", "work_id"], name: "index_artist_works_on_work"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.json "metadata"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "genre"
    t.string "style"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.json "data"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "weight", default: 1.0
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable"
  end

  create_table "songsheets", force: :cascade do |t|
    t.text "source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "metadata"
    t.bigint "track_id"
    t.string "title"
    t.index ["track_id"], name: "index_songsheets_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title"
    t.json "metadata"
    t.bigint "artist_id"
    t.bigint "album_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "has_songsheet"
    t.integer "number"
    t.integer "duration"
    t.bigint "listeners"
    t.index ["album_id"], name: "index_tracks_on_album_id"
    t.index ["artist_id"], name: "index_tracks_on_artist_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "artist_works", "artists"
  add_foreign_key "songsheets", "tracks"
end
