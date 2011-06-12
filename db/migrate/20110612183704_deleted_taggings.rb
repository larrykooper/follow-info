class DeletedTaggings < ActiveRecord::Migration
  def self.up
    create_table :deleted_taggings do |t|
      t.string :tag_name
      t.string :user_name      
      t.timestamps
    end 
  end

  def self.down
    drop_table :deleted_taggings
  end
end
