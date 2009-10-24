class AddToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :i_follow_nbr, :integer 
    add_column :users, :follows_me_nbr, :integer
  end

  def self.down
    remove_column :users, :i_follow_nbr 
    remove_column :users, :follows_me_nbr 
  end
end
