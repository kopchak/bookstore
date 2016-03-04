require 'rails_helper'

describe "Edit", js: true do
  context 'when customer not sign in' do
    before do
      @order = create(:order)
      create_cookie(:order_id, @order.id)
    end

    context 'can view' do
      it 'sign in page' do
        visit(edit_customer_path)
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
      create_cookie(:order_id, @order.id)
      visit(edit_customer_path)
    end

    context 'can view' do
      it 'the contents' do
        expect(page).to have_content(I18n.t('home.header.title_shop'))
        expect(page).to have_content(I18n.t('home.header.home_link'))
        expect(page).to have_content(I18n.t('home.header.shop_link'))
        expect(page).to have_content(I18n.t('home.header.cart'))
        expect(page).to have_content(I18n.t('home.header.settings_link'))
        expect(page).to have_content(I18n.t('home.header.orders_link'))
        expect(page).to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).to have_content(I18n.t('customers.edit.bill_addr'))
        expect(page).to have_button(I18n.t('customers.edit.submit'), count: 4)
        expect(page).to have_content(I18n.t('customers.edit.shipp_addr'))
        expect(page).to have_content(I18n.t('customers.edit.email'))
        expect(page).to have_content(I18n.t('customers.edit.passwrd'))
        expect(page).to have_content(I18n.t('customers.edit.rmv_account_title'))
        expect(page.find('.button_to')).to have_xpath("//input[@disabled='disabled']")
        expect(page.find('.button_to')).to have_xpath("//input[@type='checkbox']")
        expect(page).to have_content(I18n.t('customers.edit.checkbox_confirm_btn_rmv'))
        expect(page).not_to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_up_link'))
      end
    end

    context 'can click' do
      it 'home' do
        find('.header').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('customers.edit.bill_addr'))
      end

      it 'shop' do
        find('.header').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('customers.edit.bill_addr'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('customers.edit.bill_addr'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_content(I18n.t('customers.edit.bill_addr'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('customers.edit.bill_addr'))
      end

      it 'save billing address' do
        ba = find('.billing_address')
        ba.fill_in('First name', with: Faker::Name.first_name)
        ba.fill_in('Last name', with: Faker::Name.last_name)
        ba.fill_in('Street address', with: Faker::Address.street_address)
        ba.select('Ukraine', from: 'billing_address_country')
        ba.fill_in('City', with: Faker::Address.city)
        ba.fill_in('billing_address_zipcode', with: Faker::Number.number(5))
        ba.fill_in('billing_address_phone', with: Faker::Number.number(10))
        ba.click_button('SAVE')
        expect(page).to have_current_path(edit_customer_path)
        expect(find_field('billing_address_firstname').value).not_to be_empty
        expect(find_field('billing_address_lastname').value).not_to be_empty
        expect(find_field('billing_address_phone').value).not_to be_empty
      end

      it 'save shipping address' do
        sa = find('.shipping_address')
        sa.fill_in('First name', with: Faker::Name.first_name)
        sa.fill_in('Last name', with: Faker::Name.last_name)
        sa.fill_in('Street address', with: Faker::Address.street_address)
        sa.select('Ukraine', from: 'shipping_address_country')
        sa.fill_in('City', with: Faker::Address.city)
        sa.fill_in('shipping_address_zipcode', with: Faker::Number.number(5))
        sa.fill_in('shipping_address_phone', with: Faker::Number.number(10))
        sa.click_button('SAVE')
        expect(page).to have_current_path(edit_customer_path)
        expect(find_field('shipping_address_firstname').value).not_to be_empty
        expect(find_field('shipping_address_lastname').value).not_to be_empty
        expect(find_field('shipping_address_phone').value).not_to be_empty
      end

      it 'save email' do
        find('.edit_customer').fill_in('customer_email', with: Faker::Internet.email)
        find('.edit_customer').click_button('SAVE')
        expect(page).to have_current_path(edit_customer_path)
        expect(find_field('customer_email')).not_to eq(@customer.email)
      end

      context 'save password' do
        it 'with current password' do
          find('.update_password').fill_in('customer_current_password', with: @customer.password)
          find('.update_password').fill_in('customer_password', with: Faker::Internet.password(8))
          find('.update_password').click_button('SAVE')
          expect(page).to have_current_path(root_path)
        end

        it 'without current password' do
          find('.update_password').fill_in('customer_current_password', with: Faker::Internet.password(8))
          find('.update_password').fill_in('customer_password', with: Faker::Internet.password(8))
          find('.update_password').click_button('SAVE')
          expect(page).to have_current_path(edit_customer_path)
        end
      end

      it 'delete account' do
        find('#confirm_remove_account').click
        expect(page).to have_button(I18n.t('customers.edit.btn_rmv_account'))
        find('.button_remove_account').click
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
      end
    end
  end

end
