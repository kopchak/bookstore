class Address < ActiveRecord::Base
  validates :firstname, :lastname, :street_address, :city, :country, :zipcode, :phone, presence: true, on: :update
end
