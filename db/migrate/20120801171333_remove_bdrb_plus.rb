class RemoveBdrbPlus < ActiveRecord::Migration
  def up
    drop_table :bdrb_job_queues 
    remove_column :taggings, :is_published 
  end

  def down
  end
end
