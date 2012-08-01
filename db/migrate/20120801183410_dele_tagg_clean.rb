class DeleTaggClean < ActiveRecord::Migration
  def up
    drop_table :deleted_taggings
  end

  def down
  end
end
