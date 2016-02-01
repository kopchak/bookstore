class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string  :firstname
      t.string  :lastname
      t.string  :street_address
      t.string  :city
      t.string  :country
      t.string  :zipcode
      t.string  :phone

      t.timestamps null: false
    end
  end
end
