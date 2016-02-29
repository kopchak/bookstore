require 'rails_helper'

describe "Confirm payment", js: true do
  context 'when customer not sign in' do
    context 'can view' do
      it 'sign in page' do
        visit(checkouts_confirm_payment_path)
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
      @order = create(:order, customer_id: @customer.id, delivery_id: @delivery.id)
      create(:order_item, order_id: @order.id)
      create_cookie(:order_id, @order.id)
      visit(checkouts_confirm_payment_path)
    end

    context 'can view the contents' do
      it 'without discount' do
        expect(page).to have_content(I18n.t('checkouts.payment_header.title_shop'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.home'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.shop'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.cart'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.settings'))
        expect(page).to have_content(I18n.t('checkouts.payment_header.sign_out'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.checkout'))
        expect(page).to have_link(I18n.t('checkouts.confirm_payment.address'))
        expect(page).to have_link(I18n.t('checkouts.confirm_payment.delivery'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.payment'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.confirm'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.complete'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.credit_card'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.shipp_addr'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.order_summary'))
        expect(page).to have_selector('.edit_credit_card')
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.exp_date'))
        expect(page).to have_link(I18n.t('checkouts.confirm_payment.whats_cvv'))
        expect(page).to have_button(I18n.t('checkouts.confirm_payment.submit'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.item_total'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.shipping'))
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.order_total'))
        expect(page).not_to have_content(I18n.t('checkouts.confirm_payment.discount'))
        expect(page).not_to have_selector('.discount_cc')
      end

      it 'with discount' do
        discount = create(:discount)
        @order = create(:order, customer_id: @customer.id, discount_id: discount.id, delivery_id: @delivery.id)
        create_cookie(:order_id, @order.id)
        visit(checkouts_confirm_payment_path)
        expect(page).to have_content(I18n.t('checkouts.confirm_payment.discount'))
        expect(page).to have_selector('.discount_cc')
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

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('checkouts.payment_header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('checkouts.choose_delivery.checkout'))
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

      it 'save and continue' do
        fill_in('Card Number', with: Faker::Number.number(16) )
        fill_in('Card Code', with: Faker::Number.number(3) )
        find('.expiration_date').select("#{Time.now.mon}", from: 'credit_card_expiration_month')
        find('.expiration_date').select("#{Time.now.year}", from: 'credit_card_expiration_year')
        click_button('SAVE AND CONTINUE')
        expect(page).to have_current_path(checkouts_overview_path)
        expect(page).to have_link(I18n.t('checkouts.choose_delivery.payment'))
      end
    end
  end
end