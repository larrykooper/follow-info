class TaggingCleanup < ActiveRecord::Migration
  def up
     remove_column :taggings, :taken_care_of 
  end

  def down
  end
end
