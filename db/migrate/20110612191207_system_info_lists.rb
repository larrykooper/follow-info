class SystemInfoLists < ActiveRecord::Migration
  def self.up
     add_column :system_infos, :lists_last_update, :datetime
  end

  def self.down
    remove_column :system_infos, :lists_last_update
  end
end
