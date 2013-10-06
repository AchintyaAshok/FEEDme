class AddIndexesToTables < ActiveRecord::Migration
  def change
  	  add_index :restaurant_tables, :venue_locu_id
  	  add_index :restaurant_tables, :name

  	  add_index :table_items, :table_id
  	  add_index :table_items, :item_name

  	  add_index :users, :venmo_user_id
  end
end
