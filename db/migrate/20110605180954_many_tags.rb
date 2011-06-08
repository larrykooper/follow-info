class ManyTags < ActiveRecord::Migration
  def self.up
     create_table :tags_users do |t|     
      t.integer :tag_id 
      t.integer :user_id  
    end
    remove_column :users, :tag_id
  end

  def self.down
  end
end
