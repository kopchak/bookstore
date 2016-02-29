require 'rails_helper'

describe "Overview", js: true do
  context 'when customer not sign in' do
    context 'can view' do
      it 'sign in page' do
        visit(checkouts_overview_path)
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
      end
    end
  end

  context 'when customer sign in' do
    before do
      @customer = create(:customer)
      login_as(@customer)
      @delivery = create(:delivery)
      credit_card = create(:credit_card)
      @order = create(:order, customer_id: @customer.id, delivery_id: @delivery.id)
      @order.credit_card = credit_card
      @order.save
      create(:order_item, order_id: @order.id)
      create_cookie(:order_id, @order.id)
      visit(checkouts_overview_path)
    end

    context 'can view the contents' do
      it 'without discount' do
        expect(page).to have_content(I18n.t('checkouts.payment_header.title_shop'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.home'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.shop'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.cart'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.settings'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.sign_out'))
        expect(page).to have_link(I18n.t('checkouts.overview.address'))
        expect(page).to have_link(I18n.t('checkouts.overview.delivery'))
        expect(page).to have_link(I18n.t('checkouts.overview.payment'))
        expect(page).to have_content(I18n.t('checkouts.overview.confirm'))
        expect(page).to have_content(I18n.t('checkouts.overview.complete'))
        expect(page).to have_content(I18n.t('checkouts.overview.bill_addr'))
        expect(page).to have_content(I18n.t('checkouts.overview.shipp_addr'))
        expect(page).to have_content(I18n.t('checkouts.overview.shipments'))
        expect(page).to have_content(I18n.t('checkouts.overview.payment_info'))
        expect(page).to have_link(I18n.t('checkouts.overview.edit'), count: 4)
        expect(page).to have_content(I18n.t('checkouts.overview.book'))
        expect(page).to have_content(I18n.t('checkouts.overview.price'))
        expect(page).to have_content(I18n.t('checkouts.overview.qty'))
        expect(page).to have_content(I18n.t('checkouts.overview.total'))
        expect(page).to have_content(I18n.t('checkouts.overview.subtotal'))
        expect(page).to have_content(I18n.t('checkouts.overview.shipping'))
        expect(page).to have_content(I18n.t('checkouts.overview.order_total'))
        expect(page).to have_button(I18n.t('checkouts.overview.place_order'))
        expect(page).not_to have_content(I18n.t('checkouts.overview.discount'))
        expect(page).not_to have_selector('.discount_overview')
      end

      it 'with discount' do
        discount = create(:discount)
        credit_card = create(:credit_card)
        @order = create(:order, customer_id: @customer.id, discount_id: discount.id, delivery_id: @delivery.id)
        @order.credit_card = credit_card
        @order.save
        create_cookie(:order_id, @order.id)
        visit(checkouts_overview_path)
        expect(page).to have_content(I18n.t('checkouts.overview.discount'))
        expect(page).to have_selector('.discount_overview')
      end
    end

    context 'can click' do
      it 'home' do
        find('.header').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('checkouts.overview.confirm'))
      end

      it 'shop' do
        find('.header').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('checkouts.overview.confirm'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('checkouts.overview.confirm'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_content(I18n.t('checkouts.overview.confirm'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('checkouts.payment_header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('checkouts.overview.confirm'))
      end

      it 'address' do
        click_link('ADDRESS')
        expect(page).to have_current_path(checkouts_edit_address_path)
        expect(page).not_to have_link(I18n.t('checkouts.choose_delivery.address'))
      end

      it 'delivery' do
        click_link('DELIVERY')
        expect(page).to have_current_path(checkouts_choose_delivery_path)
        expect(page).not_to have_link(I18n.t('checkouts.choose_delivery.delivery'))
      end

      it 'payment' do
        click_link('PAYMENT')
        expect(page).to have_current_path(checkouts_confirm_payment_path)
        expect(page).not_to have_link(I18n.t('checkouts.choose_delivery.payment'))
      end

      it 'edit' do
        find('.billing_info_block').click_link('(edit)')
        expect(page).to have_current_path(checkouts_edit_address_path)
        expect(page).not_to have_link(I18n.t('checkouts.choose_delivery.address'))
      end

      it 'edit' do
        find('.shipping_info_block').click_link('(edit)')
        expect(page).to have_current_path(checkouts_edit_address_path)
        expect(page).not_to have_link(I18n.t('checkouts.choose_delivery.address'))
      end

      it 'edit' do
        find('.delivery_info_block').click_link('(edit)')
        expect(page).to have_current_path(checkouts_choose_delivery_path)
        expect(page).not_to have_link(I18n.t('checkouts.choose_delivery.delivery'))
      end

      it 'edit' do
        find('.credit_card_info_block').click_link('(edit)')
        expect(page).to have_current_path(checkouts_confirm_payment_path)
        expect(page).not_to have_link(I18n.t('checkouts.choose_delivery.payment'))
      end

      it 'place order' do
        click_button('PLACE ORDER')
        expect(page).to have_current_path(complete_order_path(@order.id))
        expect(page).to have_content(I18n.t('orders.complete.order_number'))
      end
    end
  end
end