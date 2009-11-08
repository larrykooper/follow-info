# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091101203230) do

  create_table "bdrb_job_queues", :force => true do |t|
    t.binary   "args"
    t.string   "worker_name"
    t.string   "worker_method"
    t.string   "job_key"
    t.integer  "taken"
    t.integer  "finished"
    t.integer  "timeout"
    t.integer  "priority"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.string   "tag"
    t.string   "submitter_info"
    t.string   "runner_info"
    t.string   "worker_key"
    t.datetime "scheduled_at"
  end

  create_table "deleted_pifs", :force => true do |t|
    t.string  "name"
    t.integer "nbr_followers"
    t.integer "i_follow_nbr"
    t.boolean "follows_me"
  end

  create_table "my_quitters", :force => true do |t|
    t.string  "name"
    t.integer "fmr_follows_me_nbr"
    t.boolean "i_follow"
  end

  create_table "system_infos", :force => true do |t|
    t.datetime "followers_last_update"
    t.datetime "i_follow_last_update"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "nbr_followers"
    t.boolean  "is_me"
    t.boolean  "follows_me"
    t.boolean  "i_follow"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "i_follow_nbr"
    t.integer  "follows_me_nbr"
    t.boolean  "taken_care_of"
  end

end
