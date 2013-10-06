# == Schema Information
#
# Table name: table_items
#
#  id             :integer          not null, primary key
#  table_id       :integer
#  item_name      :string(255)
#  quantity       :integer
#  price          :float
#  paid           :boolean
#  paying_user_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class TableItem < ActiveRecord::Base
	belongs_to :restaurant_table, foreign_key: :table_id
end
