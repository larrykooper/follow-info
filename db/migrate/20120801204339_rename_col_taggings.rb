class RenameColTaggings < ActiveRecord::Migration
  def up
     rename_column :taggings, :user_id, :twitter_user_id
  end

  def down
  end
end
