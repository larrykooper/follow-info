class CreateUnfollowedMe < ActiveRecord::Migration
  def self.up
    rename_column :deleted_pifs, :i_followed, :follows_me 
    create_table :my_quitters do |t|
      t.string :name
      t.integer :fmr_follows_me_nbr 
      t.boolean :i_follow        
    end
  end

  def self.down    
    rename_column :deleted_pifs, :follows_me, :i_followed
    drop_table :my_quitters 
  end
end
