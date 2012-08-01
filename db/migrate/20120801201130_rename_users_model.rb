class RenameUsersModel < ActiveRecord::Migration
  def up
    rename_table :users, :twitter_users 
  end

  def down
  end
end
