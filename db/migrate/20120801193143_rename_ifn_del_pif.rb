class RenameIfnDelPif < ActiveRecord::Migration
  def up
    rename_column :deleted_pifs, :i_follow_nbr, :fmr_i_follow_nbr
  end

  def down
  end
end
