class CreateMultiUsersTables < ActiveRecord::Migration
  def up 
    create_table :followings do |t|
      t.integer :follow_info_user_id
      t.integer :twitter_user_id
      t.boolean :tu_follows_fiu 
      t.datetime :date_tu_started_following_fiu 
      t.boolean :fiu_follows_tu 
      t.datetime :date_fiu_started_following_tu 
      t.integer :tag_id 
      t.integer :pif_number 
      t.integer :follower_number 
      t.boolean :taken_care_of
      t.timestamps
    end
    
    create_table :follow_info_users_tags do |t|
      t.integer :follow_info_user_id 
      t.integer :tag_id 
      t.boolean :is_published 
      t.timestamps       
    end
  end

  def down
    drop_table :followings
    drop_table :follow_info_users_tags
  end
end
