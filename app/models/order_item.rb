class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validates :price, :quantity, :book_id, presence: true

  default_scope { order("id") }

  def total_price
    book.price * quantity.to_i
  end
end
