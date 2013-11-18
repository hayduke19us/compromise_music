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

ActiveRecord::Schema.define(version: 20131118211505) do

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grouplists", force: true do |t|
    t.integer  "group_id"
    t.integer  "playlist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string  "name"
    t.integer "user_id"
  end

  create_table "groupships", force: true do |t|
    t.integer  "group_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "playlists", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
    t.string   "key"
    t.string   "embedUrl"
  end

  add_index "playlists", ["user_id"], name: "index_playlists_on_user_id"

  create_table "tracks", force: true do |t|
    t.string   "name"
    t.string   "key"
    t.string   "embedUrl"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "playlist_key"
    t.integer  "playlist_id",  limit: 255
    t.integer  "index"
    t.integer  "user_id"
  end

  add_index "tracks", ["playlist_id"], name: "index_tracks_on_playlist_id"
  add_index "tracks", ["user_id"], name: "index_tracks_on_user_id"

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "oauth_expires_at"
    t.binary   "image"
    t.string   "oauth_secret"
    t.string   "access_token"
    t.string   "access_secret"
    t.string   "key"
  end

  create_table "votes", force: true do |t|
    t.boolean  "vote",          default: false, null: false
    t.integer  "voteable_id",                   null: false
    t.string   "voteable_type",                 null: false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type"
  add_index "votes", ["voter_id", "voter_type", "voteable_id", "voteable_type"], name: "fk_one_vote_per_user_per_entity", unique: true
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type"

end
