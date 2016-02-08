class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category
  has_many   :ratings
  has_many   :order_items

  validates :title, :price, :stock_qty, presence: true

  mount_uploader :image, ImageUploader

  def self.bestsellers
    joins(order_items: :order)
    .where(orders: {state: ['in_queue','in_delivery','delivered']})
    .select('books.id, books.price, books.image, books.description, books.title,
            books.stock_qty, books.author_id, SUM(order_items.quantity) as quantity')
    .group('books.id').order('quantity DESC').limit(3)
  end
end
