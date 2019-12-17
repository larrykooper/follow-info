class RemoveEmailIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index "users", name: "index_follow_info_users_on_email"
  end
end
