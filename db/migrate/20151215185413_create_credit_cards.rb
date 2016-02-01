class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.string     :number
      t.string     :expiration_month
      t.string     :expiration_year
      t.string     :cvv
      t.references :customer, index: true

      t.timestamps null: false
    end
    add_foreign_key :credit_cards, :customers
  end
end
