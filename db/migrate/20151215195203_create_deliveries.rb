class CreateDeliveries < ActiveRecord::Migration
  def change
    create_table :deliveries do |t|
      t.decimal :price, precision: 5, scale: 2
      t.string  :title

      t.timestamps null: false
    end
  end
end
