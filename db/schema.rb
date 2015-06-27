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

ActiveRecord::Schema.define(version: 20150627202925) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "athletes", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "country_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "male",         default: true
    t.string   "name"
  end

  create_table "circuits", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: true do |t|
    t.integer  "athlete_id"
    t.integer  "timesheet_id"
    t.integer  "bib"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",       default: 0
  end

  add_index "entries", ["athlete_id"], name: "index_entries_on_athlete_id", using: :btree
  add_index "entries", ["timesheet_id"], name: "index_entries_on_timesheet_id", using: :btree

  create_table "points", force: true do |t|
    t.integer  "athlete_id"
    t.integer  "timesheet_id"
    t.integer  "circuit_id"
    t.integer  "season_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "runs", force: true do |t|
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

  create_table "seasons", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "timesheets", force: true do |t|
    t.string   "name"
    t.string   "nickname"
    t.integer  "track_id"
    t.integer  "circuit_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "race",       default: false
    t.integer  "season_id"
    t.string   "pdf"
    t.integer  "gender",     default: 0
    t.boolean  "complete",   default: false
  end

  add_index "timesheets", ["circuit_id"], name: "index_timesheets_on_circuit_id", using: :btree
  add_index "timesheets", ["season_id"], name: "index_timesheets_on_season_id", using: :btree
  add_index "timesheets", ["track_id"], name: "index_timesheets_on_track_id", using: :btree

  create_table "tracks", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_digest"], name: "index_users_on_remember_digest", using: :btree

end
