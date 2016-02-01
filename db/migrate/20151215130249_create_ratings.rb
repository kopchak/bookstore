class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer    :rating
      t.string     :title
      t.text       :review
      t.boolean    :check, default: false
      t.references :customer, index: true
      t.references :book, index: true

      t.timestamps null: false
    end
    add_foreign_key :ratings, :books
    add_foreign_key :ratings, :customers
  end
end
