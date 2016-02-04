class Discount < ActiveRecord::Base
  before_save :create_code
  has_many :orders
  validates :amount, presence: true

  private
    def create_code
      self.code = rand(100000..999999)
    end
end
