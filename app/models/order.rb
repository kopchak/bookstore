class Order < ActiveRecord::Base
  include AASM
  belongs_to :customer
  belongs_to :delivery
  belongs_to :discount,    dependent: :destroy
  belongs_to :credit_card, dependent: :destroy
  has_many   :order_items, dependent: :destroy
  
  after_create :create_credit_card

  accepts_nested_attributes_for :credit_card

  aasm column: :state do
    state :in_progress, initial: true
    state :in_queue
    state :in_delivery
    state :delivered
    state :canceled

    event :in_queue do
      transitions from: :in_progress, to: :in_queue
    end

    event :in_delivery do
      transitions from: :in_queue, to: :in_delivery
    end

    event :delivered do
      transitions from: :in_delivery, to: :delivered
    end

    event :canceled do
      transitions from: [:in_progress, :in_queue], to: :canceled
    end
  end

  def state_enum
    ['in_progress', 'in_queue', 'delivered', 'canceled']
  end

  private
  def create_credit_card
    self.build_credit_card
    self.save
  end
end
