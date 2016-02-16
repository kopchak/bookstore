require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  describe "abilities of admin" do
    let(:customer) { create(:customer, admin: true) }
    let(:ability)  { Ability.new(customer) }

    before do
      create(:order, customer_id: customer.id)
    end

    context 'can' do
      it { expect(ability).to be_able_to(:manage, :all) }
    end
  end

  describe "abilities of customer" do
    let(:customer) { create(:customer) }
    let(:ability)  { Ability.new(customer) }

    before do
      create(:order, customer_id: customer.id)
    end

    context 'can' do
      it { expect(ability).to be_able_to(:index, Book) }
      it { expect(ability).to be_able_to(:show, Book) }
      it { expect(ability).to be_able_to(:show, Category) }
      it { expect(ability).to be_able_to(:index, Delivery) }
      it { expect(ability).to be_able_to(:manage, CreditCard) }
      it { expect(ability).to be_able_to(:edit, Customer) }
      it { expect(ability).to be_able_to(:update_address, Customer) }
      it { expect(ability).to be_able_to(:update_email, Customer) }
      it { expect(ability).to be_able_to(:update_password, Customer) }
      it { expect(ability).to be_able_to(:index, OrderItem) }
      it { expect(ability).to be_able_to(:create, OrderItem) }
      it { expect(ability).to be_able_to(:update, OrderItem) }
      it { expect(ability).to be_able_to(:destroy, OrderItem) }
      it { expect(ability).to be_able_to(:clear_cart, OrderItem) }
      it { expect(ability).to be_able_to(:index, Order) }
      it { expect(ability).to be_able_to(:show, Order) }
      it { expect(ability).to be_able_to(:edit, Order) }
      it { expect(ability).to be_able_to(:update, Order) }
      it { expect(ability).to be_able_to(:confirmation, Order) }
      it { expect(ability).to be_able_to(:overview, Order) }
      it { expect(ability).to be_able_to(:add_discount, Order) }
      it { expect(ability).to be_able_to(:read, Rating) }
      it { expect(ability).to be_able_to(:new, Rating) }
      it { expect(ability).to be_able_to(:create, Rating) }
      it { expect(ability).to be_able_to(:edit, Address) }
      it { expect(ability).to be_able_to(:update, Address) }
    end

    context 'cannot' do
      it { expect(ability).not_to be_able_to(:manage, Author) }
      it { expect(ability).not_to be_able_to(:manage, Book) }
      it { expect(ability).not_to be_able_to(:manage, Category) }
      it { expect(ability).not_to be_able_to(:manage, Delivery) }
      it { expect(ability).not_to be_able_to(:manage, Discount) }
    end
  end

  describe "abilities of guest" do
    let(:customer) { Customer.new }
    let(:ability)  { Ability.new(customer) }

    before do
      create(:order, customer_id: customer.id)
    end

    context 'can' do
      it { expect(ability).to be_able_to(:index, Book) }
      it { expect(ability).to be_able_to(:show, Book) }
      it { expect(ability).to be_able_to(:show, Category) }
      it { expect(ability).to be_able_to(:index, OrderItem) }
      it { expect(ability).to be_able_to(:create, OrderItem) }
      it { expect(ability).to be_able_to(:update, OrderItem) }
      it { expect(ability).to be_able_to(:destroy, OrderItem) }
      it { expect(ability).to be_able_to(:clear_cart, OrderItem) }
      it { expect(ability).to be_able_to(:add_discount, Order) }
      it { expect(ability).to be_able_to(:read, Rating) }
    end

    context 'cannot' do
      it { expect(ability).not_to be_able_to(:manage, Address) }
      it { expect(ability).not_to be_able_to(:manage, Order) }
      it { expect(ability).not_to be_able_to(:manage, CreditCard) }
      it { expect(ability).not_to be_able_to(:read,   Delivery) }
      it { expect(ability).not_to be_able_to(:manage, Rating) }
    end
  end
end