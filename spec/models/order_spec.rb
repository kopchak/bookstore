require 'rails_helper'

RSpec.describe Order, :type => :model do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:delivery) }
  it { is_expected.to belong_to(:discount) }
  it { is_expected.to belong_to(:credit_card) }
  it { is_expected.to have_many(:order_items) }
  it { is_expected.to accept_nested_attributes_for(:credit_card) }

  context 'after create exist credit card' do
    before do
      @order = create(:order)
    end

    it 'credit card not nil' do
      expect(@order.credit_card).not_to be_nil
    end
  end

  context 'state' do
    before do
      @order = create(:order)
    end

    it 'after create state is in_progress' do
      expect(@order.in_progress?).to be_truthy
    end

    it 'can transition from in_progress to in_queue' do
      expect(@order.may_in_queue?).to be_truthy
    end

    it 'cannot skip in_queue state' do
      expect(@order.may_in_delivery?).to be_falsey
    end

    it 'can transition from in_queue to in_delivery' do
      @order.in_queue
      expect(@order.may_in_delivery?).to be_truthy
    end

    it 'cannot skip in_delivery state' do
      expect(@order.may_delivered?).to be_falsey
    end

    it 'can transition from in_delivery to delivered' do
      @order.in_queue
      @order.in_delivery
      expect(@order.may_delivered?).to be_truthy
    end

    it 'can transition from in_progress to canceled' do
      expect(@order.may_canceled?).to be_truthy
    end

    it 'can transition from in_queue to canceled' do
      @order.in_queue
      expect(@order.may_canceled?).to be_truthy
    end

    it 'cannot transition from in_delivery to canceled' do
      @order.in_queue
      @order.in_delivery
      expect(@order.may_canceled?).to be_falsey
    end

    it 'cannot transition from delivered to canceled' do
      @order.in_queue
      @order.in_delivery
      @order.delivered
      expect(@order.may_canceled?).to be_falsey
    end
  end
end