class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category
  has_many   :ratings
  has_many   :order_items

  validates :title, :price, :stock_qty, presence: true

  mount_uploader :image, ImageUploader
end
