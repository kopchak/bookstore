require 'rails_helper'

describe "Choose delivery", js: true do
  context 'when customer not sign in' do
    context 'can view' do
      it 'sign in page' do
        visit(checkouts_choose_delivery_path)
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
      end
    end
  end

  context 'when customer sign in' do
    before do
      @customer = create(:customer)
      login_as(@customer)
      @order = create(:order, customer_id: @customer.id)
      create(:order_item, order_id: @order.id)
      create_list(:delivery, 3)
      @deliveries = Delivery.all
      create_cookie(:order_id, @order.id)
      visit(checkouts_choose_delivery_path)
    end

    context 'can view the contents' do
      it 'without discount' do
        expect(page).to have_content(I18n.t('home.header.title_shop'))
        expect(page).to have_content(I18n.t('home.header.home_link'))
        expect(page).to have_content(I18n.t('home.header.shop_link'))
        expect(page).to have_content(I18n.t('home.header.cart'))
        expect(page).to have_content(I18n.t('home.header.settings_link'))
        expect(page).to have_content(I18n.t('home.header.orders_link'))
        expect(page).to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.checkout'))
        expect(page).to have_link(I18n.t('checkouts.choose_delivery.address'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.delivery'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.payment'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.confirm'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.complete'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.bill_addr'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.shipp_addr'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.order_summary'))
        expect(find("#order_delivery_id_#{@deliveries.first.id}")).to be_checked
        expect(page).to have_selector('.delivery', count: 3)
        expect(page).to have_button(I18n.t('checkouts.choose_delivery.submit'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.item_total_price'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.shipping_price'))
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.order_total_price'))
        expect(page).not_to have_content(I18n.t('checkouts.choose_delivery.discount'))
        expect(page).not_to have_selector('.discount_deliveries')
      end

      it 'with discount' do
        discount = create(:discount)
        @order = create(:order, customer_id: @customer.id, discount_id: discount.id)
        create_cookie(:order_id, @order.id)
        visit(checkouts_choose_delivery_path)
        expect(page).to have_content(I18n.t('checkouts.choose_delivery.discount'))
        expect(page).to have_selector('.discount_deliveries')
      end
    end

    context 'can click' do
      it 'home' do
        find('.header').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('checkouts.choose_delivery.checkout'))
      end

      it 'shop' do
        find('.header').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('checkouts.choose_delivery.checkout'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_link(I18n.t('checkouts.choose_delivery.address'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_content(I18n.t('checkouts.choose_delivery.checkout'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_content(I18n.t('checkouts.choose_delivery.checkout'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('checkouts.choose_delivery.checkout'))
      end

      it 'address' do
        click_link('ADDRESS')
        expect(page).to have_current_path(checkouts_edit_address_path)
        expect(page).not_to have_link(I18n.t('checkouts.choose_delivery.address'))
      end

      it 'save and continue' do
        click_button('SAVE AND CONTINUE')
        expect(page).to have_current_path(checkouts_confirm_payment_path)
        expect(page).to have_link(I18n.t('checkouts.choose_delivery.delivery'))
      end
    end

    context 'can choose any delivery' do
      before do
        find("#order_delivery_id_#{@deliveries.last.id}").click
      end

      it 'any radio button' do
        expect(find("#order_delivery_id_#{@deliveries.last.id}")).to be_checked
      end

      it 'change delivery price info' do
        expect(find(".delivery_price_info")).to have_content("#{@deliveries.last.price}")
      end
    end
    
  end

end

