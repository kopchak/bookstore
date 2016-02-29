require 'rails_helper'

describe "Show", js: true do
  before do
    @book = create(:book)
    order = create(:order)
    create_cookie(:order_id, order.id)
  end

  context 'when customer not sign in' do
    before do
      visit(new_book_rating_path(@book.id))
    end

    context 'can view' do
      it 'sign in page' do
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
      end
    end
  end

  context 'when customer sign in' do
    before do
      @customer = create(:customer)
      login_as(@customer)
      visit(new_book_rating_path(@book.id))
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
        expect(page).to have_content(I18n.t('ratings.new.new_review'))
        expect(page).to have_content(I18n.t('ratings.new.rating'))
        expect(page).to have_content(I18n.t('ratings.new.title'))
        expect(page).to have_content(I18n.t('ratings.new.text_review'))
        expect(page).to have_button(I18n.t('ratings.new.submit'))
        expect(page).to have_content(I18n.t('ratings.new.or'))
        expect(page).to have_link(I18n.t('ratings.new.cancel'))
      end
    end

    context 'can click' do
      it 'home' do
        click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('ratings.new.new_review'))
      end

      it 'shop' do
        click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('ratings.new.new_review'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('ratings.new.new_review'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_content(I18n.t('ratings.new.new_review'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_content(I18n.t('ratings.new.new_review'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('ratings.new.new_review'))
      end

      it 'link title book' do
        click_link("#{@book.title}")
        expect(page).to have_current_path(book_path(@book.id))
        expect(page).to have_button(I18n.t('books.show.submit'))
        expect(page).not_to have_link("#{@book.title}")
      end

      it 'add' do
        find('.new_rating').select('4', from: 'rating_rating')
        find('.new_rating').fill_in('rating_title', with: Faker::Lorem.sentence )
        find('.new_rating').fill_in('rating_review', with: Faker::Lorem.paragraph )
        click_button('ADD')
        expect(page).to have_current_path(book_path(@book.id))
        expect(page).to have_button(I18n.t('books.show.submit'))
        expect(page).not_to have_link("#{@book.title}")
      end

      it 'cancel' do
        click_link('Cancel')
        expect(page).to have_current_path(book_path(@book.id))
        expect(page).to have_button(I18n.t('books.show.submit'))
        expect(page).not_to have_link("#{@book.title}")
      end
    end
  end
end