require 'rails_helper'

describe "Show", js: true do
  before do
    category1 = create(:category)
    category2 = create(:category)
    create_list(:book, 5, category_id: category1.id)
    create_list(:book, 5, category_id: category2.id)
    @categories = Category.has_book
    visit(category_path(@categories.first.id))
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
        expect(page).to have_content(I18n.t('categories.show.home'))
        expect(page).to have_content(I18n.t('categories.show.shop'))
        expect(page).to have_content(I18n.t('categories.show.categories'))
        expect(page).to have_selector('.book', count: 5)
        expect(page).to have_selector('.pagination')
        expect(find('.links_to_home_shop')).to have_link('Home')
        expect(find('.links_to_home_shop')).to have_link('Shop')
        expect(find('.links_to_home_shop')).to have_link(@categories.first.title)
        expect(find('.categories')).to have_selector('li', count: @categories.count)
        expect(find('.categories')).to have_content(I18n.t('categories.show.book_categories'))
        expect(page).not_to have_content(I18n.t('home.header.settings_link'))
        expect(page).not_to have_content(I18n.t('home.header.orders_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
      end
    end

    context 'can click' do
      it 'home' do
        find('.header').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'shop' do
        find('.header').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'sign in' do
        click_link('Sign in')
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'sign up' do
        click_link('Sign up')
        expect(page).to have_current_path(new_customer_registration_path)
        expect(page).to have_selector('.facebook_image')
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'category title' do
        click_link(@categories.last.title)
        expect(page).to have_current_path(category_path(@categories.last.id))
        expect(page).to have_content(I18n.t('categories.show.categories'))
      end

      it 'book title' do
        click_link(@categories.first.books.first.title)
        expect(page).to have_current_path(book_path(@categories.first.books.first.id))
        expect(page).to have_content(I18n.t('books.show.reviews_title'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'home, higher category title' do
        find('.links_to_home_shop').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'shop, higher category title' do
        find('.links_to_home_shop').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'category.title, higher category title' do
        find('.links_to_home_shop').click_link(@categories.first.title)
        expect(page).to have_current_path(category_path(@categories.first.id))
        expect(page).to have_content(I18n.t('categories.show.categories'))
      end
    end
  end

  context 'when customer sign in' do
    before do
      @customer = create(:customer)
      login_as(@customer)
      visit(category_path(@categories.first.id))
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
        expect(page).to have_content(I18n.t('categories.show.home'))
        expect(page).to have_content(I18n.t('categories.show.shop'))
        expect(page).to have_content(I18n.t('categories.show.categories'))
        expect(page).to have_selector('.book', count: 5)
        expect(page).to have_selector('.pagination')
        expect(find('.links_to_home_shop')).to have_link('Home')
        expect(find('.links_to_home_shop')).to have_link('Shop')
        expect(find('.links_to_home_shop')).to have_link(@categories.first.title)
        expect(find('.categories')).to have_selector('li', count: @categories.count)
        expect(find('.categories')).to have_content(I18n.t('categories.show.book_categories'))
        expect(page).not_to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_up_link'))
      end
    end

    context 'can click' do
      it 'home' do
        find('.header').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'shop' do
        find('.header').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'category title' do
        click_link(@categories.last.title)
        expect(page).to have_current_path(category_path(@categories.last.id))
        expect(page).to have_content(I18n.t('categories.show.categories'))
      end

      it 'book title' do
        click_link(@categories.first.books.first.title)
        expect(page).to have_current_path(book_path(@categories.first.books.first.id))
        expect(page).to have_content(I18n.t('books.show.reviews_title'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'home, higher category title' do
        find('.links_to_home_shop').click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'shop, higher category title' do
        find('.links_to_home_shop').click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('categories.show.categories'))
      end

      it 'category.title, higher category title' do
        find('.links_to_home_shop').click_link(@categories.first.title)
        expect(page).to have_current_path(category_path(@categories.first.id))
        expect(page).to have_content(I18n.t('categories.show.categories'))
      end
    end
  end
end