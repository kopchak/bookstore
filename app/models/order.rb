class Order < ActiveRecord::Base
  include AASM
  belongs_to :customer
  belongs_to :delivery
  belongs_to :discount
  belongs_to :credit_card
  has_many   :order_items

  # validates :total_price, :completed_date, :state, presence: true

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

end
