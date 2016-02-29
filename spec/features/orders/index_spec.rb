require 'rails_helper'

describe "Index", js: true do
  context 'when customer not sign in' do
    before do
      @order = create(:order)
      create_cookie(:order_id, @order.id)
    end

    context 'can view' do
      it 'sign in page' do
        visit(orders_path)
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
      end
    end
  end

  context 'when customer sign in' do
    before do
      @customer = create(:customer)
      delivery = create(:delivery)
      @order = create(:order, customer_id: @customer.id, delivery_id: delivery.id)
      create(:order_item, order_id: @order.id)
      @order2 = create(:order, customer_id: @customer.id, delivery_id: delivery.id, state: 'in_queue')
      create(:order_item, order_id: @order2.id)
      create_list(:order, 2, customer_id: @customer.id, state: 'in_delivery')
      create_list(:order, 2, customer_id: @customer.id, state: 'delivered')
      login_as(@customer)
      create_cookie(:order_id, @order.id)
      visit(orders_path)
    end

    context 'can view the contents' do
      it 'without discount' do
        expect(page).to have_content(I18n.t('home.header.title_shop'))
        expect(page).to have_content(I18n.t('home.header.home_link'))
        expect(page).to have_content(I18n.t('home.header.shop_link'))
        expect(page).to have_content(I18n.t('home.header.settings_link'))
        expect(page).to have_content(I18n.t('home.header.orders_link'))
        expect(page).to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).to have_content(I18n.t('orders.index.in_progress'))
        expect(page).to have_content(I18n.t('orders.index.book'))
        expect(page).to have_content(I18n.t('orders.index.price'))
        expect(page).to have_content(I18n.t('orders.index.qty'))
        expect(page).to have_content(I18n.t('orders.index.total'))
        expect(page).to have_content(I18n.t('orders.index.subtotal'))
        expect(page).to have_content(I18n.t('orders.index.in_queue'))
        expect(page).to have_content(I18n.t('orders.index.number'))
        expect(page).to have_content(I18n.t('orders.index.completed_at'))
        expect(page).to have_content(I18n.t('orders.index.total_column'))
        expect(page.find('.order_in_progress')).to have_selector('.order_item_line', count: @order.order_items.count)
        expect(page.find('.orders_in_queue')).to have_selector('.order_line', count: @customer.orders.in_queue.count)
        expect(page.find('.orders_in_delivery')).to have_selector('.order_line', count: @customer.orders.in_delivery.count)
        expect(page.find('.orders_delivered')).to have_selector('.order_line', count: @customer.orders.delivered.count)
        expect(page).to have_selector('.order_in_progress')
        expect(page).to have_selector('.orders_in_queue')
        expect(page).to have_selector('.orders_in_delivery')
        expect(page).to have_selector('.orders_delivered')
        expect(page).to have_content(I18n.t('orders.index.order_number'))
        expect(page).to have_content(I18n.t('orders.index.view_link'))
        expect(page).to have_content(I18n.t('orders.index.in_queue'))
        expect(page).to have_content(I18n.t('orders.index.in_delivery'))
        expect(page).to have_content(I18n.t('orders.index.delivered'))
        expect(page).not_to have_content(I18n.t('orders.index.discount'))
      end

      it 'with discount' do
        discount = create(:discount)
        order = create(:order, customer_id: @customer.id, discount_id: discount.id)
        create(:order_item, order_id: order.id)
        create_cookie(:order_id, order.id)
        visit(orders_path)
        expect(page).to have_content(I18n.t('orders.index.discount'))
      end
    end

    context 'can click' do
      it 'home' do
        click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('orders.index.in_progress'))
      end

      it 'shop' do
        click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('orders.index.in_progress'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('orders.index.in_progress'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_content(I18n.t('orders.index.in_progress'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('orders.index.orders'))
      end

      it 'order#' do
        click_link("Order ##{@order2.id}")
        expect(page).to have_current_path(order_path(@order2.id))
        expect(page).to have_link(I18n.t('orders.show.back_to_orders'))
        expect(page).not_to have_content(I18n.t('orders.index.in_queue'))
      end

      it 'view' do
        find('.orders_in_queue').click_link('view')
        expect(page).to have_current_path(order_path(@order2.id))
        expect(page).to have_link(I18n.t('orders.show.back_to_orders'))
        expect(page).not_to have_content(I18n.t('orders.index.in_queue'))
      end
    end
  end
end