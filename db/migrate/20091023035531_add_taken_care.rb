class AddTakenCare < ActiveRecord::Migration
  def self.up
    add_column :users, :taken_care_of, :boolean
  end

  def self.down
    remove_column :users, :taken_care_of 
  end
end
