class RenameDelsCols < ActiveRecord::Migration
  def up
    rename_column :deleted_followers, :fmr_follows_me_nbr, :fmr_follower_number 
    rename_column :deleted_followers, :i_follow, :fiu_follows_tu 
    rename_column :deleted_pifs, :fmr_i_follow_nbr, :fmr_pif_number 
    rename_column :deleted_pifs, :follows_me, :tu_follows_fiu 
    add_column    :deleted_followers, :follow_info_user_id, :integer 
    add_column    :deleted_followers, :date_tu_started_following_fiu, :datetime 
    add_column    :deleted_pifs, :follow_info_user_id, :integer 
    add_column    :deleted_pifs, :date_fiu_started_following_tu, :datetime 
  end

  def down
  end
end
