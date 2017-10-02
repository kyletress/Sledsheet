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

ActiveRecord::Schema.define(version: 20170304224257) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "link"
    t.integer "athlete_id"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "athletes", id: :serial, force: :cascade do |t|
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.string "country_code", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "male", default: true
    t.string "avatar", limit: 255
    t.string "user_id"
    t.integer "gender", default: 0
    t.string "rss_alert_url"
    t.string "slug"
    t.index ["slug"], name: "index_athletes_on_slug", unique: true
    t.index ["user_id"], name: "index_athletes_on_user_id"
  end

  create_table "circuits", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "nickname"
    t.string "slug"
    t.index ["slug"], name: "index_circuits_on_slug", unique: true
  end

  create_table "entries", id: :serial, force: :cascade do |t|
    t.integer "athlete_id"
    t.integer "timesheet_id"
    t.integer "bib"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "status", default: 0
    t.integer "runs_count", default: 0, null: false
    t.index ["athlete_id"], name: "index_entries_on_athlete_id"
    t.index ["timesheet_id", "athlete_id"], name: "index_entries_on_timesheet_id_and_athlete_id", unique: true
    t.index ["timesheet_id"], name: "index_entries_on_timesheet_id"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.integer "sender_id"
    t.string "recipient_email"
    t.string "token"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pg_search_documents", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "searchable_id"
    t.string "searchable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "points", id: :serial, force: :cascade do |t|
    t.integer "athlete_id"
    t.integer "timesheet_id"
    t.integer "circuit_id"
    t.integer "season_id"
    t.integer "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["athlete_id"], name: "index_points_on_athlete_id"
    t.index ["circuit_id"], name: "index_points_on_circuit_id"
    t.index ["season_id"], name: "index_points_on_season_id"
    t.index ["timesheet_id"], name: "index_points_on_timesheet_id"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.integer "athlete_id"
    t.string "favorite_track"
    t.string "favorite_curve"
    t.string "coach"
    t.string "location"
    t.string "hometown"
    t.string "twitter"
    t.string "instagram"
    t.string "facebook"
    t.string "rallyme"
    t.string "sled"
    t.text "about"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "runs", id: :serial, force: :cascade do |t|
    t.integer "entry_id", null: false
    t.integer "start"
    t.integer "split2"
    t.integer "split3"
    t.integer "split4"
    t.integer "split5"
    t.integer "finish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position"
    t.integer "int1"
    t.integer "int2"
    t.integer "int3"
    t.integer "int4"
    t.integer "int5"
    t.integer "status", default: 0
    t.index ["entry_id"], name: "index_runs_on_entry_id"
  end

  create_table "seasons", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug"
    t.index ["slug"], name: "index_seasons_on_slug", unique: true
  end

  create_table "timesheets", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "nickname", limit: 255
    t.integer "track_id"
    t.integer "circuit_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "race", default: false
    t.integer "season_id"
    t.string "pdf", limit: 255
    t.integer "gender", default: 0
    t.boolean "complete", default: false
    t.integer "status", default: 0
    t.integer "visibility", default: 0
    t.integer "user_id"
    t.jsonb "weather"
    t.string "slug"
    t.string "type"
    t.index ["circuit_id"], name: "index_timesheets_on_circuit_id"
    t.index ["season_id"], name: "index_timesheets_on_season_id"
    t.index ["slug"], name: "index_timesheets_on_slug", unique: true
    t.index ["track_id"], name: "index_timesheets_on_track_id"
    t.index ["user_id"], name: "index_timesheets_on_user_id"
  end

  create_table "tracks", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "time_zone"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "slug"
    t.index ["slug"], name: "index_tracks_on_slug", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "password_digest", limit: 255
    t.string "remember_digest", limit: 255
    t.boolean "admin", default: false
    t.integer "invitation_id"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "time_zone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_digest"], name: "index_users_on_remember_digest"
  end

  add_foreign_key "timesheets", "users"
end
