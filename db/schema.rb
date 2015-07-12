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

ActiveRecord::Schema.define(version: 20150712005456) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "athletes", force: :cascade do |t|
    t.string   "first_name",   limit: 255
    t.string   "last_name",    limit: 255
    t.string   "country_code", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "male",                     default: true
    t.string   "avatar",       limit: 255
  end

  create_table "circuits", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "athlete_id"
    t.integer  "timesheet_id"
    t.integer  "bib"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",       default: 0
  end

  add_index "entries", ["athlete_id"], name: "index_entries_on_athlete_id", using: :btree
  add_index "entries", ["timesheet_id"], name: "index_entries_on_timesheet_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "notifiable_id"
    t.string  "notifiable_type"
  end

  create_table "points", force: :cascade do |t|
    t.integer  "athlete_id"
    t.integer  "timesheet_id"
    t.integer  "circuit_id"
    t.integer  "season_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "points", ["athlete_id"], name: "index_points_on_athlete_id", using: :btree
  add_index "points", ["circuit_id"], name: "index_points_on_circuit_id", using: :btree
  add_index "points", ["season_id"], name: "index_points_on_season_id", using: :btree
  add_index "points", ["timesheet_id"], name: "index_points_on_timesheet_id", using: :btree

  create_table "runs", force: :cascade do |t|
    t.integer  "entry_id",               null: false
    t.integer  "start"
    t.integer  "split2"
    t.integer  "split3"
    t.integer  "split4"
    t.integer  "split5"
    t.integer  "finish"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.integer  "int1"
    t.integer  "int2"
    t.integer  "int3"
    t.integer  "int4"
    t.integer  "int5"
    t.integer  "status",     default: 0
  end

  add_index "runs", ["entry_id"], name: "index_runs_on_entry_id", using: :btree

  create_table "seasons", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timesheets", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "nickname",   limit: 255
    t.integer  "track_id"
    t.integer  "circuit_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "race",                   default: false
    t.integer  "season_id"
    t.string   "pdf",        limit: 255
    t.integer  "gender",                 default: 0
    t.boolean  "complete",               default: false
  end

  add_index "timesheets", ["circuit_id"], name: "index_timesheets_on_circuit_id", using: :btree
  add_index "timesheets", ["season_id"], name: "index_timesheets_on_season_id", using: :btree
  add_index "timesheets", ["track_id"], name: "index_timesheets_on_track_id", using: :btree

  create_table "tracks", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255, default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest",        limit: 255
    t.string   "remember_digest",        limit: 255
    t.boolean  "admin",                              default: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",                  default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["remember_digest"], name: "index_users_on_remember_digest", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
