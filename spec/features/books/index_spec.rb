require 'rails_helper'

describe "Index", js: true do
  before do
    ctgry1 = create(:category)
    ctgry2 = create(:category)
    create_list(:book, 5, category_id: ctgry1.id)
    create_list(:book, 5, category_id: ctgry2.id)
    create_list(:book, 5)
    @first_book = Book.first
    @categories = Category.has_book
    visit(books_path)
  end

  context 'when customer not sign in' do
    context 'can view' do
      it 'the contents' do
        expect(page).to have_content(I18n.t('home.header.title_shop'))
        expect(page).to have_content(I18n.t('home.header.home_link'))
        expect(page).to have_content(I18n.t('home.header.shop_link'))
        expect(page).to have_content(I18n.t('home.header.cart'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).to have_content(I18n.t('books.index.categories'))
        expect(page).not_to have_content(I18n.t('home.header.settings_link'))
        expect(page).not_to have_content(I18n.t('home.header.orders_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).to have_selector('.book', count: 6)
        expect(page).to have_selector('.pagination')
        expect(page.find('.categories')).to have_selector('li', count: @categories.count)
      end
    end

    context 'can click' do
      it 'category title' do
        click_link(@categories.first.title)
        expect(page).to have_current_path(category_path(@categories.first.id))
      end

      it 'next' do
        click_link('Next ›')
        expect(page).to have_current_path('/books?page=2')
      end

      it 'home' do
        click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('books.index.categories'))
      end

      it 'shop' do
        click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('books.index.categories'))
      end

      it 'sign in' do
        click_link('Sign in')
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
        expect(page).not_to have_content(I18n.t('books.index.categories'))
      end

      it 'sign up' do
        click_link('Sign up')
        expect(page).to have_current_path(new_customer_registration_path)
        expect(page).to have_selector('.facebook_image')
        expect(page).not_to have_content(I18n.t('books.index.categories'))
      end
    end
  end

  context 'when customer sign in' do
    before do
      @customer = create(:customer)
      login_as(@customer)
      visit(books_path)
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
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).to have_content(I18n.t('books.index.categories'))
        expect(page).not_to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).to have_selector('.book', count: 6)
        expect(page).to have_selector('.pagination')
        expect(page.find('.categories')).to have_selector('li', count: @categories.count)
      end
    end

    context 'can click' do
      it 'category title' do
        click_link(@categories.first.title)
        expect(page).to have_current_path(category_path(@categories.first.id))
      end

      it 'next' do
        click_link('Next ›')
        expect(page).to have_current_path('/books?page=2')
      end

      it 'home' do
        click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('books.index.categories'))
      end

      it 'shop' do
        click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.categories'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('books.index.categories'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_content(I18n.t('books.index.categories'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_content(I18n.t('books.index.categories'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('books.index.categories'))
      end
    end
  end
  
end