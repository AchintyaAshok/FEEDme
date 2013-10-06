class AddVemoUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :venmo_user_id, :string
  end
end
