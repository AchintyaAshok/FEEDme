# == Schema Information
#
# Table name: restaurant_tables
#
#  id            :integer          not null, primary key
#  venue_locu_id :string(255)      not null
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class RestaurantTable < ActiveRecord::Base
	has_many :restaurant_table_users
	has_many :users, through: :restaurant_table_users
end
