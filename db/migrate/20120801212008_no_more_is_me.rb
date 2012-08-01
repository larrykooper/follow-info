class NoMoreIsMe < ActiveRecord::Migration
  def up
    remove_column :twitter_users, :is_me
  end

  def down
  end
end
