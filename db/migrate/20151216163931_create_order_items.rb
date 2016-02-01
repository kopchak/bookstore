class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.decimal    :price, precision: 6, scale: 2
      t.integer    :quantity
      t.references :book, index: true
      t.references :order, index: true

      t.timestamps null: false
    end
    add_foreign_key :order_items, :books
    add_foreign_key :order_items, :orders
  end
end
