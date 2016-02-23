require 'rails_helper'

describe "Customer do", js: true do
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

  # it 'can visit books page' do
  #   expect(page).to have_content(I18n.t('home.header.title_shop'))
  #   expect(page).to have_content(I18n.t('home.header.home_link'))
  #   expect(page).to have_content(I18n.t('home.header.shop_link'))
  #   expect(page).to have_content(I18n.t('home.header.cart'))
  #   expect(page).to have_content(I18n.t('home.header.sign_in_link'))
  #   expect(page).to have_content(I18n.t('home.header.sign_up_link'))
  #   expect(page).to have_content(I18n.t('books.index.shop_title'))
    # expect(page).to have_content(I18n.t('books.index.categories'))
  #   expect(page).to have_selector('.book', count: 6)
  #   expect(page).to have_selector('.pagination')
  #   expect(page.find('.categories')).to have_selector('li', count: @categories.count)
  #   # page.save_screenshot('screenshot.png')
  # end

  # it 'can click link book title' do
  #   click_link(@first_book.title)
  #   expect(page).to have_current_path(book_path(@first_book.id))
  #   expect(page).to have_content(@first_book.title)
  #   expect(page).to have_content(@first_book.price)
  #   expect(page).to have_content(@first_book.description)
  #   expect(page).to have_content(I18n.t('books.show.reviews_title'))
  #   expect(page).to have_button(I18n.t('books.show.submit'))
  #   # page.save_screenshot('screenshot.png')
  # end

  it 'can click link category title' do
    click_link(@categories.first.title)
    expect(page).to have_current_path(category_path(@categories.first.id))
    expect(page).to have_content(I18n.t('categories.show.home'))
    expect(page).to have_content(I18n.t('categories.show.shop'))
    expect(page).to have_content(I18n.t('categories.show.categories'))
    eexpect(page.find('.categories')).to have_selector('li', count: @categories.count)
    expect(page).to have_selector('.book', count: 5)
    page.save_screenshot('screenshot.png')
  end
end