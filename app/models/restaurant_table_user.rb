# == Schema Information
#
# Table name: restaurant_table_users
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  restaurant_table_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class RestaurantTableUser < ActiveRecord::Base
  belongs_to :restaurant_table
  belongs_to :user
end
