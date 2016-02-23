class Category < ActiveRecord::Base
  has_many :books
  
  validates :title, presence: true, uniqueness: true

  scope :has_book, -> { joins(:books).distinct.order(:id) }
end
