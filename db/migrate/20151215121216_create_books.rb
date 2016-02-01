class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string     :title
      t.decimal    :price, precision: 6, scale: 2
      t.integer    :stock_qty
      t.text       :description
      t.string     :image
      t.references :author, index: true
      t.references :category, index: true

      t.timestamps null: false
    end
    add_foreign_key :books, :authors
    add_foreign_key :books, :categories
  end
end
