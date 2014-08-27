class AddRecommendCountToUsers < ActiveRecord::Migration
  #def change
  #end

  def self.up
    add_column :users, :recommendation_count, :integer
  end

  def self.down
    remove_column :users, :recommendation_count
  end
end
