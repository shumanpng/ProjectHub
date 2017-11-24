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

ActiveRecord::Schema.define(version: 20171120071104) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_users", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "change_passwords", force: :cascade do |t|
    t.string   "current_password"
    t.string   "new_password"
    t.string   "confirm_password"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "points", force: :cascade do |t|
    t.integer  "level"
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "task_id"
    t.boolean  "grp_admin"
    t.text     "task_comment"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "user_name"
    t.boolean  "isadmin"
  end

  create_table "tasks", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "created_by"
    t.datetime "deadline"
    t.integer  "points"
    t.string   "group"
    t.string   "state"
    t.string   "task_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "group_id"
    t.integer  "assigned_to"
  end

  create_table "user_logins", force: :cascade do |t|
    t.string   "email"
    t.string   "password"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.boolean  "is_admin"
    t.string   "password"
    t.string   "email"
    t.datetime "date_created"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  create_table "widgets", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
