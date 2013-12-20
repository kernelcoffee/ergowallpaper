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

ActiveRecord::Schema.define(version: 20130911181703) do

  create_table "album_assignments", force: true do |t|
    t.integer  "wallpaper_id"
    t.integer  "album_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "albums", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "public",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aspect_ratios", force: true do |t|
    t.string   "name"
    t.decimal  "ratio",      precision: 12, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colorations", force: true do |t|
    t.integer  "r"
    t.integer  "b"
    t.integer  "g"
    t.string   "hex"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colorizations", force: true do |t|
    t.integer  "wallpaper_id"
    t.integer  "coloration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "wallpaper_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resolutions", force: true do |t|
    t.integer  "width"
    t.integer  "height"
    t.integer  "multi",           default: 3
    t.boolean  "portrait",        default: true
    t.integer  "aspect_ratio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", force: true do |t|
    t.string   "keywords"
    t.string   "geometry"
    t.string   "color"
    t.boolean  "portrait"
    t.boolean  "checked",        default: true
    t.boolean  "reviewed",       default: true
    t.boolean  "purity_safe",    default: true
    t.boolean  "purity_sketchy", default: false
    t.boolean  "purity_nsfw",    default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "similitudes", force: true do |t|
    t.integer  "wallpaper_id"
    t.integer  "similar_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",                   limit: 50
    t.boolean  "admin",                             default: false
    t.boolean  "public",                            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wallpapers", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "format"
    t.integer  "filesize"
    t.integer  "purity"
    t.string   "fingerprint"
    t.string   "author"
    t.string   "author_website"
    t.integer  "multi",          default: 1
    t.boolean  "portrait",       default: false
    t.boolean  "processed",      default: false
    t.boolean  "reviewed",       default: false
    t.integer  "user_id"
    t.integer  "resolution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
