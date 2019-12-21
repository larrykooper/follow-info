class GetRidOfTaggings < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :tag_id, :integer

    execute <<-SQL
      UPDATE users
        SET tag_id = tagids.tag_id
        FROM (SELECT tag_id, user_id
        FROM taggings) tagids
        WHERE users.id = tagids.user_id
      ;
    SQL

    drop_table :taggings
  end
end
