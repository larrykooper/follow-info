class AddLastTimeTweeted < ActiveRecord::Migration
  def self.up
    add_column :users, :last_time_tweeted, :datetime
  end

  def self.down
    remove_column :users, :last_time_tweeted
  end
end
