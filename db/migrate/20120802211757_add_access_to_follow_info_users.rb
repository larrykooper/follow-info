class AddAccessToFollowInfoUsers < ActiveRecord::Migration
  def up    
    change_table :follow_info_users do |t|
      t.string   :access_token
      t.string   :access_secret
      t.datetime :followers_last_update 
      t.datetime :pifs_last_update
    end
  end
  
  def down
  end
    
end
