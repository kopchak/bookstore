class Rating < ActiveRecord::Base
  belongs_to :customer
  belongs_to :book
  
  validates :rating, :title, :review, :customer_id, presence: true
end
