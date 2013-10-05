class CreateRestaurantTableUsers < ActiveRecord::Migration
  def change
    create_table :restaurant_table_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :restaurant_table, index: true

      t.timestamps
    end
  end
end
