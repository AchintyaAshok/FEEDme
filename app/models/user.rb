class User < ActiveRecord::Base
	has_many :restaurant_table_users
	has_many :restaurant_tables, through: :restaurant_table_users
end
