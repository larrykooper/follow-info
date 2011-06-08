class AddTags < ActiveRecord::Migration
  def self.up
     create_table :tags do |t|
      t.string :name      
      t.timestamps
    end
    add_column :users, :tag_id, :integer 
  end

  def self.down
    drop_table :tags 
    remove_column :users, :tag_id
  end
end
