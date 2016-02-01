class Delivery < ActiveRecord::Base
  has_many :orders

  validates :price, :title, presence: true

  default_scope { order("id") }
end
