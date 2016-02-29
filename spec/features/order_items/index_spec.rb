require 'rails_helper'

describe "Index", js: true do
  context 'when customer not sign in' do
    before do
      @order = create(:order)
      create_list(:order_item, 3, order_id: @order.id)
      create_cookie(:order_id, @order.id)
      visit(order_items_path)
    end

    context 'can view the contents' do
      it 'without discount' do
        expect(page).to have_content(I18n.t('order_items.header.title_shop'))
        expect(page).to have_content(I18n.t('order_items.header.home_link'))
        expect(page).to have_content(I18n.t('order_items.header.shop_link'))
        expect(page).to have_content(I18n.t('order_items.header.sign_in_link'))
        expect(page).to have_content(I18n.t('order_items.header.sign_up_link'))
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).to have_content(I18n.t('order_items.index.book'))
        expect(page).to have_content(I18n.t('order_items.index.price'))
        expect(page).to have_content(I18n.t('order_items.index.qty'))
        expect(page).to have_content(I18n.t('order_items.index.total'))
        expect(page).to have_selector('.order_item', count: 3)
        expect(page).to have_link(I18n.t('order_items.index.delete_order_item'))
        expect(page).to have_content(I18n.t('order_items.index.subtotal'))
        expect(page).to have_link(I18n.t('order_items.index.btn_empty_cart'))
        expect(page).to have_link(I18n.t('order_items.index.btn_continue_shipping'))
        expect(page).to have_button(I18n.t('order_items.index.submit_dicount'))
        expect(page).to have_link(I18n.t('order_items.index.checkout'))
        expect(page).not_to have_content(I18n.t('order_items.index.discount'))
        expect(page).not_to have_selector('order_items.index.discount')
      end

      it 'with discount' do
        discount = create(:discount)
        @order = create(:order, discount_id: discount.id)
        create_list(:order_item, 3, order_id: @order.id)
        create_cookie(:order_id, @order.id)
        visit(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.discount'))
        expect(page).to have_selector('.discount')
      end
    end

    context 'can click' do
      it 'home' do
        click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'shop' do
        click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'sign in' do
        click_link('Sign in')
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'sign up' do
        click_link('Sign up')
        expect(page).to have_current_path(new_customer_registration_path)
        expect(page).to have_selector('.facebook_image')
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'empty cart' do
        expect(page).to have_selector('.order_item', count: 3)
        click_link('EMPTY CART')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_selector('.order_item')
      end

      it 'continue shoping' do
        click_link('CONTINUE SHOPING')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.categories'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'checkout' do
        click_link('CHECKOUT')
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      context 'update' do
        it 'with exist discount' do
          discount = create(:discount)
          find('#new_discount').fill_in('discount_code', with: discount.code)
          click_button('UPDATE')
          expect(page).to have_content(I18n.t('order_items.index.discount'))
          expect(page).to have_selector('.discount')
        end

        it 'without exist discount' do
          find('#new_discount').fill_in('discount_code', with: '111111')
          click_button('UPDATE')
          expect(page).not_to have_content(I18n.t('order_items.index.discount'))
          expect(page).not_to have_selector('.discount')
        end
      end
    end

  end

  context 'when customer sign in' do
    before do
      @customer = create(:customer)
      @order = create(:order, customer_id: @customer.id)
      create_list(:order_item, 3, order_id: @order.id)
      create_cookie(:order_id, @order.id)
      login_as(@customer)
      visit(order_items_path)
    end

    context 'can view the contents' do
      it 'without discount' do
        expect(page).to have_content(I18n.t('order_items.header.title_shop'))
        expect(page).to have_content(I18n.t('order_items.header.home_link'))
        expect(page).to have_content(I18n.t('order_items.header.shop_link'))
        expect(page).to have_content(I18n.t('order_items.header.settings_link'))
        expect(page).to have_content(I18n.t('order_items.header.orders_link'))
        expect(page).to have_content(I18n.t('order_items.header.sign_out_link'))
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).to have_content(I18n.t('order_items.index.book'))
        expect(page).to have_content(I18n.t('order_items.index.price'))
        expect(page).to have_content(I18n.t('order_items.index.qty'))
        expect(page).to have_content(I18n.t('order_items.index.total'))
        expect(page).to have_link(I18n.t('order_items.index.delete_order_item'))
        expect(page).to have_content(I18n.t('order_items.index.subtotal'))
        expect(page).to have_link(I18n.t('order_items.index.btn_empty_cart'))
        expect(page).to have_link(I18n.t('order_items.index.btn_continue_shipping'))
        expect(page).to have_button(I18n.t('order_items.index.submit_dicount'))
        expect(page).to have_link(I18n.t('order_items.index.checkout'))
        expect(page).not_to have_content(I18n.t('order_items.index.discount'))
        expect(page).not_to have_selector('order_items.index.discount')
      end

      it 'with discount' do
        discount = create(:discount)
        @order = create(:order, customer_id: @customer.id, discount_id: discount.id)
        create_list(:order_item, 3, order_id: @order.id)
        create_cookie(:order_id, @order.id)
        visit(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.discount'))
        expect(page).to have_selector('.discount')
      end
    end

    context 'can click' do
      it 'home' do
        find('.header').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'shop' do
        find('.header').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

    it 'empty cart' do
        expect(page).to have_selector('.order_item', count: 3)
        click_link('EMPTY CART')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_selector('.order_item')
      end

      it 'continue shoping' do
        click_link('CONTINUE SHOPING')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.categories'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      it 'checkout' do
        click_link('CHECKOUT')
        expect(page).to have_current_path(checkouts_edit_address_path)
        expect(page).to have_content(I18n.t('checkouts.edit_address.checkout'))
        expect(page).not_to have_link(I18n.t('order_items.index.checkout'))
      end

      context 'update' do
        it 'with exist discount' do
          discount = create(:discount)
          find('#new_discount').fill_in('discount_code', with: discount.code)
          click_button('UPDATE')
          expect(page).to have_content(I18n.t('order_items.index.discount'))
          expect(page).to have_selector('.discount')
        end

        it 'without exist discount' do
          find('#new_discount').fill_in('discount_code', with: '111111')
          click_button('UPDATE')
          expect(page).not_to have_content(I18n.t('order_items.index.discount'))
          expect(page).not_to have_selector('.discount')
        end
      end
    end
  end
end