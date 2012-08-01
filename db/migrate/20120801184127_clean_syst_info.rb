class CleanSystInfo < ActiveRecord::Migration
  def up
     remove_column :system_infos, :lists_last_update 
  end

  def down
  end
end
