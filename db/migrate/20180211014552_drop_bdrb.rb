class DropBdrb < ActiveRecord::Migration[5.1]
  def change
    drop_table :bdrb_job_queues
  end
end
