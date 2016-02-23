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
    ['in_queue', 'in_delivery', 'delivered', 'canceled']
  end

  def items_price
    self.order_items.sum(:price)
  end

  def items_quantity
    self.order_items.sum(:quantity)
  end

  def add_book(book_id, qty)
    if order_item = self.order_items.find_by(book_id: book_id)
      order_item.quantity += qty
      order_item.price += order_item.book.price * qty
    else
      order_item = self.order_items.new(book_id: book_id, quantity: qty)
      order_item.price = order_item.book.price * qty
    end
    order_item.save
  end

  def add_discount(coupon)
    if coupon.new_state && self.discount.nil?
      coupon.update(new_state: false)
      self.discount = coupon
      self.save
    end
  end

  def set_total_price
    if self.discount
      self.total_price = self.items_price + self.delivery.price - self.discount.amount
    else
      self.total_price = self.items_price + self.delivery.price
    end
    self.save
  end

  def confirm(current_user)
    self.customer_id = current_user.id
    self.in_queue
    self.completed_date = 3.days.from_now
    self.save
  end

  private
  def create_credit_card
    self.build_credit_card
    self.save
  end
end
