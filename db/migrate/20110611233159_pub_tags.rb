class PubTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :is_published, :boolean
  end

  def self.down
    remove_column :tags, :is_published 
  end
end
