class CreateSystemInfo < ActiveRecord::Migration
  def self.up
    create_table :system_infos do |t|
      t.datetime :followers_last_update 
      t.datetime :i_follow_last_update       
    end     
  end

  def self.down
    drop_table :system_infos
  end
end
