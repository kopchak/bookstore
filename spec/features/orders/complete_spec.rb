require 'rails_helper'

describe "Complete", js: true do
  context 'when customer not sign in' do
    before do
      @order = create(:order)
      create_cookie(:order_id, @order.id)
    end

    context 'can view' do
      it 'sign in page' do
        visit(complete_order_path(@order.id))
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
      end
    end
  end

  context 'when customer sign in' do
    before do
      @customer = create(:customer)
      delivery = create(:delivery)
      credit_card = create(:credit_card)
      @order = create(:order, customer_id: @customer.id, delivery_id: delivery.id)
      create(:order_item, order_id: @order.id)
      @order.credit_card = credit_card
      @order.save
      create_cookie(:order_id, @order.id)
      login_as(@customer)
      visit(complete_order_path(@order.id))
    end

    context 'can view the contents' do
      it 'without discount' do
        expect(page).to have_content(I18n.t('order_items.header.title_shop'))
        expect(page).to have_content(I18n.t('order_items.header.home_link'))
        expect(page).to have_content(I18n.t('order_items.header.shop_link'))
        expect(page).to have_content(I18n.t('order_items.header.settings_link'))
        expect(page).to have_content(I18n.t('order_items.header.orders_link'))
        expect(page).to have_content(I18n.t('order_items.header.sign_out_link'))
        expect(page).to have_content(I18n.t('orders.complete.order_number'))
        expect(page).to have_content(I18n.t('orders.complete.confirm'))
        expect(page).to have_content(I18n.t('orders.complete.bill_addr'))
        expect(page).to have_content(I18n.t('orders.complete.shipp_addr'))
        expect(page).to have_content(I18n.t('orders.complete.shipments'))
        expect(page).to have_content(I18n.t('orders.complete.payment_info'))
        expect(page).to have_content(I18n.t('orders.complete.book'))
        expect(page).to have_content(I18n.t('orders.complete.price'))
        expect(page).to have_content(I18n.t('orders.complete.qty'))
        expect(page).to have_content(I18n.t('orders.complete.total'))
        expect(page).to have_selector('.order_item')
        expect(page).to have_content(I18n.t('orders.complete.subtotal'))
        expect(page).to have_content(I18n.t('orders.complete.shipping'))
        expect(page).to have_content(I18n.t('orders.complete.order_total'))
        expect(page).to have_button(I18n.t('orders.complete.go_store'))
        expect(page).not_to have_content(I18n.t('orders.complete.discount'))
      end

      it 'with discount' do
        discount = create(:discount)
        credit_card = create(:credit_card)
        delivery = create(:delivery)
        @order = create(:order, customer_id: @customer.id, discount_id: discount.id, delivery_id: delivery.id)
        @order.credit_card = credit_card
        @order.save
        create_cookie(:order_id, @order.id)
        visit(complete_order_path(@order.id))
        expect(page).to have_content(I18n.t('orders.complete.discount'))
      end
    end

    context 'can click' do
      it 'home' do
        find('.header').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('orders.complete.order_number'))
      end

      it 'shop' do
        find('.header').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('orders.complete.order_number'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_content(I18n.t('orders.complete.order_number'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_content(I18n.t('orders.complete.order_number'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('checkouts.payment_header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('orders.complete.order_number'))
      end

      it 'go back to store' do
        click_button('GO BACK TO STORE')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('orders.complete.order_number'))
      end
    end
  end
end