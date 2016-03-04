require 'rails_helper'

describe "Show", js: true do
  context 'when customer not sign in' do
    before do
      @order = create(:order, state: 'in_queue')
    end

    context 'can view' do
      it 'sign in page' do
        visit(order_path(@order.id))
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
      end
    end
  end

  context 'when customer sign in' do
    before do
      @customer = create(:customer)
      @delivery = create(:delivery)
      @order = create(:order, customer_id: @customer.id, delivery_id: @delivery.id, state: 'in_queue')
      create(:order_item, order_id: @order.id)
      login_as(@customer)
      visit(order_path(@order.id))
    end

    context 'can view the contents' do
      it 'without discount' do
        expect(page).to have_content(I18n.t('order_items.header.title_shop'))
        expect(page).to have_content(I18n.t('order_items.header.home_link'))
        expect(page).to have_content(I18n.t('order_items.header.shop_link'))
        expect(page).to have_content(I18n.t('order_items.header.settings_link'))
        expect(page).to have_content(I18n.t('order_items.header.orders_link'))
        expect(page).to have_content(I18n.t('order_items.header.sign_out_link'))
        expect(page).to have_link(I18n.t('orders.show.back_to_orders'))
        expect(page).to have_content(I18n.t('orders.show.order_number'))
        expect(page).to have_content(I18n.t('orders.show.book'))
        expect(page).to have_content(I18n.t('orders.show.price'))
        expect(page).to have_content(I18n.t('orders.show.qty'))
        expect(page).to have_content(I18n.t('orders.show.total'))
        expect(page).to have_content(I18n.t('orders.show.subtotal'))
        expect(page).to have_content(I18n.t('orders.show.shipping'))
        expect(page).to have_content(I18n.t('orders.show.order_total'))
        expect(page).not_to have_content(I18n.t('orders.show.discount'))
      end

      it 'with discount' do
        discount = create(:discount)
        order = create(:order, customer_id: @customer.id, delivery_id: @delivery.id, discount_id: discount.id, state: 'in_queue')
        create(:order_item, order_id: order.id)
        visit(order_path(order.id))
        expect(page).to have_content(I18n.t('orders.show.discount'))
      end
    end

    context 'can click' do
      it 'home' do
        find('.header').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_link(I18n.t('orders.show.back_to_orders'))
      end

      it 'shop' do
        find('.header').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_link(I18n.t('orders.show.back_to_orders'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_link(I18n.t('orders.show.back_to_orders'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_link(I18n.t('orders.show.back_to_orders'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('checkouts.payment_header.sign_out_link'))
        expect(page).not_to have_link(I18n.t('orders.show.back_to_orders'))
      end

      it 'back to orders' do
        click_link('< Back to orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_link(I18n.t('orders.show.back_to_orders'))
      end
    end
  end
end
