# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
	has_many :restaurant_table_users
	has_many :restaurant_tables, through: :restaurant_table_users
end
