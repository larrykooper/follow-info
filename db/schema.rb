# Larry 12/16/2019

# In order to create the test database for testing, I had to change:

#  create_table "deleted_pifs", id: :integer, default: -> { "nextval('deleted_pifs_id_seq1'::regclass)" }, force: :cascade do |t|
# to
#  create_table "deleted_pifs", id: :serial, force: :cascade do |t|

# I made that change because when I ran:
#  bundle exec rake db:schema:load RAILS_ENV=test
# I would get:

# ActiveRecord::StatementInvalid: PG::UndefinedTable: ERROR:  relation "deleted_pifs_id_seq1" does not exist
# : CREATE TABLE "deleted_pifs" ("id" integer DEFAULT nextval('deleted_pifs_id_seq1'::regclass) NOT NULL PRIMARY KEY, "name" character varying, "nbr_followers" integer, "i_follow_nbr" integer, "follows_me" boolean)

# However, I don't want to check that change in, because manually editing
# schema.rb is a no-no. So if I really want to make that change ("nextval" to "serial")
# in my actual database tables, I will need to create a migration to do so.

# OR, I could just figure out why that sequence problem is happening.
# ======================================================================

# Also note that it may not be that important what the migration says for that stuff,
#  it seems to be dependent on the Rails version:

# https://stackoverflow.com/questions/54598531/what-determines-if-rails-includes-id-serial-in-a-table-definition

# ======================================================================

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

ActiveRecord::Schema.define(version: 20191216201340) do

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

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "user_id"
    t.boolean "is_published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "taken_care_of"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_published"
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
  end

end
