require 'rails_helper'

describe "Edit address", js: true do
  context 'when customer not sign in' do
    context 'can view' do
      it 'sign in page' do
        visit(checkouts_edit_address_path)
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
      create_cookie(:order_id, @order.id)
      visit(checkouts_edit_address_path)
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
        expect(page).to have_content(I18n.t('checkouts.edit_address.checkout'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.address'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.delivery'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.payment'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.confirm'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.complete'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.billing_address'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.shipping_address'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.order_summary'))
        expect(page).to have_button(I18n.t('checkouts.edit_address.submit'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.use_bill_addr'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.item_total'))
        expect(page).to have_content(I18n.t('checkouts.edit_address.order_total'))
        expect(page).not_to have_selector('.shipping_address_form')
        expect(page).not_to have_content(I18n.t('checkouts.edit_address.discount'))
        expect(page).not_to have_selector('.discount')
        page.save_screenshot('screenshot.png')
      end

      it 'with discount' do
        discount = create(:discount)
        @order = create(:order, customer_id: @customer.id, discount_id: discount.id)
        create_cookie(:order_id, @order.id)
        visit(checkouts_edit_address_path)
        expect(page).to have_content(I18n.t('checkouts.edit_address.discount'))
        expect(page).to have_selector('.discount')
      end
    end

    context 'can click' do
      it 'home' do
        find('.header').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('checkouts.edit_address.checkout'))
      end

      it 'shop' do
        find('.header').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('checkouts.edit_address.checkout'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('checkouts.edit_address.address'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_content(I18n.t('checkouts.edit_address.checkout'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_content(I18n.t('checkouts.edit_address.checkout'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('checkouts.edit_address.checkout'))
      end

      it 'use billing address' do
        find('#use_billing_address').click
        expect(page).to have_selector('.shipping_address_form')
      end

      it 'save and continue' do
        create_list(:delivery, 3)
        fill_in('First name', with: Faker::Name.first_name)
        fill_in('Last name', with: Faker::Name.last_name)
        fill_in('Street address', with: Faker::Address.street_address)
        find('.billing_address_form').select('Ukraine', from: 'customer_billing_address_attributes_country')
        fill_in('City', with: Faker::Address.city)
        fill_in('customer_billing_address_attributes_zipcode', with: Faker::Number.number(5))
        fill_in('customer_billing_address_attributes_phone', with: Faker::Number.number(10))
        click_button('SAVE AND CONTINUE')
        expect(page).to have_current_path(checkouts_choose_delivery_path)
        expect(page).to have_link(I18n.t('checkouts.edit_address.address'))
      end
    end

  end

end

