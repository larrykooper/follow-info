class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name 
      t.integer :nbr_followers 
      t.boolean :is_me 
      t.boolean :follows_me
      t.boolean :i_follow 
      t.timestamps
    end
  end

  def self.down
    drop_table :users 
  end
end
