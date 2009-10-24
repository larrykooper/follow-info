class CreatePifsDeleted < ActiveRecord::Migration
  def self.up
    create_table :deleted_pifs do |t|
      t.string :name
      t.integer :nbr_followers 
      t.integer :i_follow_nbr 
      t.boolean :i_followed 
    end 
  end

  def self.down
    drop_table :deleted_pifs 
  end
end
