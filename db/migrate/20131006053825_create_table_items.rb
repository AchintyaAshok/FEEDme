class CreateTableItems < ActiveRecord::Migration
  def change
    create_table :table_items do |t|
      t.integer :table_id
      t.string :item_name
      t.integer :quantity
      t.float :price
      t.boolean :paid
      t.integer :paying_user_id

      t.timestamps
    end
  end
end
