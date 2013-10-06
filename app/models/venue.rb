# == Schema Information
#
# Table name: venues
#
#  id            :integer          not null, primary key
#  venue_locu_id :string(255)
#  venmo_user_id :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Venue < ActiveRecord::Base
end
