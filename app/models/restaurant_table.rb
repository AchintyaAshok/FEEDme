class RestaurantTable < ActiveRecord::Base
	has_many :restaurant_table_users
	has_many :users, through: :restaurant_table_users
end
