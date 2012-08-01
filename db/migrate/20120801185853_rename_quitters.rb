class RenameQuitters < ActiveRecord::Migration
  def up
    rename_table :my_quitters, :deleted_followers
  end

  def down
  end
end
