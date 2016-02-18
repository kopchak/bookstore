class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validates :quantity, :book_id, presence: true

  default_scope { order("id") }

end
