class DeviseInvitableAddToUsers < ActiveRecord::Migration
  def up
     change_table :follow_info_users do |t|
        t.string   :invitation_token,     :limit => 60
        t.datetime :invitation_sent_at
        t.index    :invitation_token
        t.integer  :invitation_limit,  :default => 0, :null => true
        t.integer  :invited_by_id
        t.string   :invited_by_type
      end

      # And allow null encrypted_password and password_salt:
      change_column :follow_info_users, :encrypted_password, :string, :null => true 
  end

  def down
  end
end
