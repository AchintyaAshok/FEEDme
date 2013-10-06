class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :venue_locu_id
      t.string :venmo_user_id

      t.timestamps
    end
  end
end
