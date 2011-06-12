class TaggingTakeCare < ActiveRecord::Migration
  def self.up
    add_column :taggings, :taken_care_of, :boolean   
  end

  def self.down
    remove_column :taggings, :taken_care_of 
  end
end
