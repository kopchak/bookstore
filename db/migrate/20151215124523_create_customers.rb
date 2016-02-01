class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.boolean :admin, default: false
      t.integer :billing_address_id, index: true
      t.integer :shipping_address_id, index: true

      t.timestamps null: false
    end

  end
end
