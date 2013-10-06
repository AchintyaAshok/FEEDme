class ChangeVenueLocuIdTypeInRestaurantTable < ActiveRecord::Migration
   def self.up
   change_column :restaurant_tables, :venue_locu_id, :string
  end

  def self.down
   change_column :restaurant_tables, :venue_locu_id, :integer
  end
end
