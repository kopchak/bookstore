require 'rails_helper'

describe "Show", js: true do
  before do
    @book = create(:book)
    @customer = create(:customer)
    visit(book_path(@book.id))
  end

  context 'when customer not sign in' do
    context 'can view' do
      before do
        @rating = create(:rating, book_id: @book.id, customer_id: @customer.id, check: true)
        visit(book_path(@book.id))
      end

      it 'the contents' do
        expect(page).to have_content(I18n.t('home.header.title_shop'))
        expect(page).to have_content(I18n.t('home.header.home_link'))
        expect(page).to have_content(I18n.t('home.header.shop_link'))
        expect(page).to have_content(I18n.t('home.header.cart'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).to have_content(@book.title)
        expect(page).to have_content(@book.price)
        expect(page).to have_content(@book.description)
        expect(page).to have_content(I18n.t('books.show.reviews_title'))
        expect(page).to have_button(I18n.t('books.show.submit'))
        expect(page).not_to have_content(I18n.t('home.header.settings_link'))
        expect(page).not_to have_content(I18n.t('home.header.orders_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('books.show.add_review'))
      end

      it 'approved reviews' do
        expect(page).to have_content(I18n.t('books.show.rating_qty'))
        expect(page).to have_content(@rating.rating)
        expect(page).to have_content(@rating.title)
        expect(page).to have_content(@rating.created_at.strftime("%B %e, %Y"))
        expect(page).to have_content(I18n.t('books.show.by'))
        expect(page).to have_content(@rating.customer.email)
        expect(page).to have_content(@rating.review)
      end
    end

    context 'can click' do
      it 'home' do
        click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'shop' do
        click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'sign in' do
        click_link('Sign in')
        expect(page).to have_current_path(new_customer_session_path)
        expect(page).to have_selector('.facebook_image')
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'sign up' do
        click_link('Sign up')
        expect(page).to have_current_path(new_customer_registration_path)
        expect(page).to have_selector('.facebook_image')
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'add to cart' do
        click_button('Add to cart')
        expect(find('.header')).to have_content(@book.price)
      end
    end

    context 'can fill' do
      it 'input book qty' do
        find('.new_order_item').fill_in('order_item_quantity', with: 2)
        click_button('Add to cart')
        expect(find('.header')).to have_content(@book.price * 2)
        expect(find('.header')).to have_content(2)
      end
    end
  end

  context 'when customer sign in' do
    before do
      login_as(@customer)
      visit(book_path(@book.id))
    end

    context 'can view' do
      before do
        @rating = create(:rating, book_id: @book.id, customer_id: @customer.id, check: true)
        visit(book_path(@book.id))
      end

      it 'the contents' do
        expect(page).to have_content(I18n.t('home.header.title_shop'))
        expect(page).to have_content(I18n.t('home.header.home_link'))
        expect(page).to have_content(I18n.t('home.header.shop_link'))
        expect(page).to have_content(I18n.t('home.header.cart'))
        expect(page).to have_content(I18n.t('home.header.settings_link'))
        expect(page).to have_content(I18n.t('home.header.orders_link'))
        expect(page).to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).to have_content(I18n.t('books.show.add_review'))
        expect(page).to have_content(@book.title)
        expect(page).to have_content(@book.price)
        expect(page).to have_content(@book.description)
        expect(page).to have_content(I18n.t('books.show.reviews_title'))
        expect(page).to have_button(I18n.t('books.show.submit'))
        expect(page).not_to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_up_link'))
      end

      it 'approved reviews' do
        expect(page).to have_content(I18n.t('books.show.rating_qty'))
        expect(page).to have_content(@rating.rating)
        expect(page).to have_content(@rating.title)
        expect(page).to have_content(@rating.created_at.strftime("%B %e, %Y"))
        expect(page).to have_content(I18n.t('books.show.by'))
        expect(page).to have_content(@rating.customer.email)
        expect(page).to have_content(@rating.review)
      end
    end

    context 'can click' do
      it 'home' do
        click_link('Home')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'shop' do
        click_link('Shop')
        expect(page).to have_current_path(books_path)
        expect(page).to have_content(I18n.t('books.index.shop_title'))
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'cart' do
        click_link('Cart')
        expect(page).to have_current_path(order_items_path)
        expect(page).to have_content(I18n.t('order_items.index.cart'))
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'settings' do
        click_link('Settings')
        expect(page).to have_current_path(edit_customer_path)
        expect(page).to have_content(I18n.t('customers.edit.settings'))
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'orders' do
        click_link('Orders')
        expect(page).to have_current_path(orders_path)
        expect(page).to have_content(I18n.t('orders.index.orders'))
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'sign out' do
        click_link('Sign out')
        expect(page).to have_current_path(root_path)
        expect(page).to have_content(I18n.t('home.index.greeting'))
        expect(page).to have_content(I18n.t('home.header.sign_in_link'))
        expect(page).to have_content(I18n.t('home.header.sign_up_link'))
        expect(page).not_to have_content(I18n.t('home.header.sign_out_link'))
        expect(page).not_to have_content(I18n.t('books.show.reviews_title'))
      end

      it 'add to cart' do
        click_button('Add to cart')
        expect(find('.header')).to have_content(@book.price)
      end

      it 'add review' do
        click_link('Add review for this book')
        expect(page).to have_current_path(new_book_rating_path(@book.id))
        expect(page).to have_content(I18n.t('ratings.new.new_review'))
      end
    end

    context 'can fill' do
      it 'book qty' do
        find('.new_order_item').fill_in('order_item_quantity', with: 2)
        click_button('Add to cart')
        expect(find('.header')).to have_content(@book.price * 2)
        expect(find('.header')).to have_content(2)
      end
    end
  end

end