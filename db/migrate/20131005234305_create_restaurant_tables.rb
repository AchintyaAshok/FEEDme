class CreateRestaurantTables < ActiveRecord::Migration
  def change
    create_table :restaurant_tables do |t|
      t.integer :venue_locu_id, null: false
      t.string :name	
      t.timestamps
    end
  end
end
