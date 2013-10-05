class RestaurantTableUser < ActiveRecord::Base
  belongs_to :restaurant_table
  belongs_to :user
end
