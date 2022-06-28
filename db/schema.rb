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

ActiveRecord::Schema[7.0].define(version: 2022_06_27_160851) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"

  create_table "access_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "jti"
    t.datetime "expire_at"
    t.datetime "invalidated_at"
    t.string "refresh_token_digest"
    t.string "remote_ip"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["jti"], name: "index_access_tokens_on_jti", unique: true
    t.index ["refresh_token_digest"], name: "index_access_tokens_on_refresh_token_digest", unique: true
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "ahoy_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.uuid "visit_id"
    t.uuid "user_id"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.uuid "user_id"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "albums", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "released"
    t.decimal "score", precision: 3, scale: 1
    t.bigint "listeners"
    t.bigint "rank"
    t.uuid "artist_id"
    t.uuid "genre_id"
    t.index ["artist_id"], name: "index_albums_on_artist_id"
    t.index ["genre_id"], name: "index_albums_on_genre_id"
  end

  create_table "artist_works", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "work_type", null: false
    t.integer "order"
    t.uuid "artist_id", null: false
    t.uuid "work_id", null: false
    t.index ["artist_id", "work_id", "work_type", "order"], name: "uniq_by_artist_and_work", unique: true
    t.index ["artist_id"], name: "index_artist_works_on_artist_id"
    t.index ["work_type", "work_id"], name: "index_artist_works_on_work"
  end

  create_table "artists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "style"
    t.boolean "verified", default: false
    t.bigint "listeners"
    t.bigint "rank"
    t.uuid "genre_id"
    t.index ["genre_id"], name: "index_artists_on_genre_id"
  end

  create_table "genres", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumbnail"
    t.bigint "listeners"
    t.bigint "rank"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at", precision: nil
    t.datetime "performed_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at", precision: nil
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "library_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "item_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.uuid "item_id", null: false
    t.index ["item_type", "item_id"], name: "index_library_items_on_item"
    t.index ["user_id"], name: "index_library_items_on_user_id"
  end

  create_table "mailkick_subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "subscriber_type"
    t.string "list"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "subscriber_id"
    t.index ["subscriber_type", "subscriber_id", "list"], name: "index_mailkick_subscriptions_on_subscriber_and_list", unique: true
  end

  create_table "motor_alert_locks", force: :cascade do |t|
    t.bigint "alert_id", null: false
    t.string "lock_timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_id", "lock_timestamp"], name: "index_motor_alert_locks_on_alert_id_and_lock_timestamp", unique: true
    t.index ["alert_id"], name: "index_motor_alert_locks_on_alert_id"
  end

  create_table "motor_alerts", force: :cascade do |t|
    t.bigint "query_id", null: false
    t.string "name", null: false
    t.text "description"
    t.text "to_emails", null: false
    t.boolean "is_enabled", default: true, null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_alerts_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["query_id"], name: "index_motor_alerts_on_query_id"
    t.index ["updated_at"], name: "index_motor_alerts_on_updated_at"
  end

  create_table "motor_api_configs", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.text "preferences", null: false
    t.text "credentials", null: false
    t.text "description"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_api_configs_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "motor_audits", force: :cascade do |t|
    t.string "auditable_id"
    t.string "auditable_type"
    t.string "associated_id"
    t.string "associated_type"
    t.bigint "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.bigint "version", default: 0
    t.text "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "motor_auditable_associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "motor_auditable_index"
    t.index ["created_at"], name: "index_motor_audits_on_created_at"
    t.index ["request_uuid"], name: "index_motor_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "motor_auditable_user_index"
  end

  create_table "motor_configs", force: :cascade do |t|
    t.string "key", null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_motor_configs_on_key", unique: true
    t.index ["updated_at"], name: "index_motor_configs_on_updated_at"
  end

  create_table "motor_dashboards", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["title"], name: "motor_dashboards_title_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_dashboards_on_updated_at"
  end

  create_table "motor_forms", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "api_path", null: false
    t.string "http_method", null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.string "api_config_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_forms_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_forms_on_updated_at"
  end

  create_table "motor_queries", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.text "sql_body", null: false
    t.text "preferences", null: false
    t.bigint "author_id"
    t.string "author_type"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_queries_name_unique_index", unique: true, where: "(deleted_at IS NULL)"
    t.index ["updated_at"], name: "index_motor_queries_on_updated_at"
  end

  create_table "motor_resources", force: :cascade do |t|
    t.string "name", null: false
    t.text "preferences", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_motor_resources_on_name", unique: true
    t.index ["updated_at"], name: "index_motor_resources_on_updated_at"
  end

  create_table "motor_taggable_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "taggable_id", null: false
    t.string "taggable_type", null: false
    t.index ["tag_id"], name: "index_motor_taggable_tags_on_tag_id"
    t.index ["taggable_id", "taggable_type", "tag_id"], name: "motor_polymorphic_association_tag_index", unique: true
  end

  create_table "motor_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "motor_tags_name_unique_index", unique: true
  end

  create_table "setlist_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "setlist_id"
    t.uuid "songsheet_id"
    t.index ["setlist_id"], name: "index_setlist_items_on_setlist_id"
    t.index ["songsheet_id"], name: "index_setlist_items_on_songsheet_id"
  end

  create_table "setlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "rank"
    t.uuid "user_id"
    t.index ["user_id"], name: "index_setlists_on_user_id"
  end

  create_table "songsheets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "metadata"
    t.string "title"
    t.string "imported_from"
    t.bigint "rank"
    t.uuid "track_id"
    t.index ["track_id"], name: "index_songsheets_on_track_id"
  end

  create_table "tracks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number"
    t.integer "duration"
    t.bigint "listeners"
    t.integer "songsheets_count", default: 0
    t.bigint "rank"
    t.uuid "artist_id"
    t.uuid "album_id"
    t.uuid "genre_id"
    t.index ["album_id"], name: "index_tracks_on_album_id"
    t.index ["artist_id"], name: "index_tracks_on_artist_id"
    t.index ["genre_id", "listeners"], name: "index_tracks_on_genre_id_and_listeners"
    t.index ["genre_id"], name: "index_tracks_on_genre_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "item_type", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.json "object"
    t.datetime "created_at"
    t.json "object_changes"
    t.uuid "item_id", null: false
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "access_tokens", "users"
  add_foreign_key "ahoy_events", "ahoy_visits", column: "visit_id"
  add_foreign_key "ahoy_events", "users"
  add_foreign_key "ahoy_visits", "users"
  add_foreign_key "albums", "artists"
  add_foreign_key "albums", "genres"
  add_foreign_key "artist_works", "artists"
  add_foreign_key "artists", "genres"
  add_foreign_key "library_items", "users"
  add_foreign_key "motor_alert_locks", "motor_alerts", column: "alert_id"
  add_foreign_key "motor_alerts", "motor_queries", column: "query_id"
  add_foreign_key "motor_taggable_tags", "motor_tags", column: "tag_id"
  add_foreign_key "setlist_items", "setlists"
  add_foreign_key "setlist_items", "songsheets"
  add_foreign_key "setlists", "users"
  add_foreign_key "songsheets", "tracks"
  add_foreign_key "tracks", "albums"
  add_foreign_key "tracks", "artists"
  add_foreign_key "tracks", "genres"
end
