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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120802212531) do

  create_table "deleted_followers", :force => true do |t|
    t.string   "name"
    t.integer  "fmr_follower_number"
    t.boolean  "fiu_follows_tu"
    t.integer  "follow_info_user_id"
    t.datetime "date_tu_started_following_fiu"
  end

  create_table "deleted_pifs", :force => true do |t|
    t.string   "name"
    t.integer  "nbr_followers"
    t.integer  "fmr_pif_number"
    t.boolean  "tu_follows_fiu"
    t.integer  "follow_info_user_id"
    t.datetime "date_fiu_started_following_tu"
  end

  create_table "follow_info_users", :force => true do |t|
    t.string   "email",                                :default => "", :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.integer  "invitation_limit",                     :default => 0
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.string   "access_token"
    t.string   "access_secret"
    t.datetime "followers_last_update"
    t.datetime "pifs_last_update"
  end

  add_index "follow_info_users", ["email"], :name => "index_follow_info_users_on_email", :unique => true
  add_index "follow_info_users", ["invitation_token"], :name => "index_follow_info_users_on_invitation_token"
  add_index "follow_info_users", ["reset_password_token"], :name => "index_follow_info_users_on_reset_password_token", :unique => true

  create_table "follow_info_users_tags", :force => true do |t|
    t.integer  "follow_info_user_id"
    t.integer  "tag_id"
    t.boolean  "is_published"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "followings", :force => true do |t|
    t.integer  "follow_info_user_id"
    t.integer  "twitter_user_id"
    t.boolean  "tu_follows_fiu"
    t.datetime "date_tu_started_following_fiu"
    t.boolean  "fiu_follows_tu"
    t.datetime "date_fiu_started_following_tu"
    t.integer  "tag_id"
    t.integer  "pif_number"
    t.integer  "follower_number"
    t.boolean  "taken_care_of"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "system_infos", :force => true do |t|
    t.datetime "followers_last_update"
    t.datetime "i_follow_last_update"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "twitter_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_published"
  end

  create_table "twitter_users", :force => true do |t|
    t.string   "name"
    t.integer  "nbr_followers"
    t.boolean  "follows_me"
    t.boolean  "i_follow"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "i_follow_nbr"
    t.integer  "follows_me_nbr"
    t.boolean  "taken_care_of"
    t.datetime "last_time_tweeted"
  end

end
