class Discount < ActiveRecord::Base
  after_initialize :create_code
  has_many :orders
  validates :code, :amount, presence: true

  private
    def create_code
      self.code = rand(100000..999999)
    end
end
