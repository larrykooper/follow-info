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

ActiveRecord::Schema.define(version: 20191221155943) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deleted_followers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "fmr_follower_number"
    t.boolean "fiu_follows_tu"
    t.integer "follow_info_user_id"
    t.datetime "date_tu_started_following_fiu"
  end

  create_table "deleted_pifs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "nbr_followers"
    t.integer "i_follow_nbr"
    t.boolean "follows_me"
  end

  create_table "follow_info_users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", limit: 128, default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reset_password_token"], name: "index_follow_info_users_on_reset_password_token", unique: true
  end

  create_table "my_quitters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "fmr_follows_me_nbr"
    t.boolean "i_follow"
  end

  create_table "system_infos", id: :serial, force: :cascade do |t|
    t.datetime "followers_last_update"
    t.datetime "i_follow_last_update"
    t.datetime "lists_last_update"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_published"
  end

  create_table "users", id: false, force: :cascade do |t|
    t.integer "id", null: false
    t.string "name"
    t.integer "nbr_followers"
    t.boolean "is_me"
    t.boolean "follows_me"
    t.boolean "i_follow"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "i_follow_nbr"
    t.integer "follows_me_nbr"
    t.boolean "taken_care_of"
    t.datetime "last_time_tweeted"
    t.integer "recommendation_count"
    t.integer "tag_id"
  end

end
