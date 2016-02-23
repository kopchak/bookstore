require 'rails_helper'

describe "Customer do", js: true do
  before do
    @order1 = create(:order, state: 'in_queue')
    oi1 = create(:order_item, order_id: @order1.id)
    @order2 = create(:order, state: 'in_delivery')
    oi2 = create(:order_item, order_id: @order2.id)
    @order3 = create(:order, state: 'in_delivery')
    oi3 = create(:order_item, order_id: @order3.id)
    @bestsellers = Book.bestsellers
    visit(root_path)
  end

  it "can visit home page" do
    expect(page).to have_content(I18n.t('home.header.title_shop'))
    expect(page).to have_content(I18n.t('home.header.home_link'))
    expect(page).to have_content(I18n.t('home.header.shop_link'))
    expect(page).to have_content(I18n.t('home.header.cart'))
    expect(page).to have_content(I18n.t('home.header.sign_in_link'))
    expect(page).to have_content(I18n.t('home.header.sign_up_link'))
    expect(page).to have_button(I18n.t('home.index.add_to_cart'))
    expect(page).to have_content(I18n.t('home.index.greeting'))
    expect(page).to have_content(@bestsellers.first.title)
    expect(page).to have_content(@bestsellers.first.description)
    expect(page).to have_content(@bestsellers.first.price)
    expect(page).to have_content(@bestsellers.first.author.firstname)
    expect(page).to have_content(@bestsellers.first.author.lastname)
  end

  it 'can use slider' do
    click_link('Next')
    expect(page).to have_content(@bestsellers[1].title)
    expect(page).to have_content(@bestsellers[1].description)
    expect(page).to have_content(@bestsellers[1].price)
    expect(page).to have_content(@bestsellers[1].author.firstname)
    expect(page).to have_content(@bestsellers[1].author.lastname)
    click_link('Next')
    expect(page).to have_content(@bestsellers.last.title)
    expect(page).to have_content(@bestsellers.last.description)
    expect(page).to have_content(@bestsellers.last.price)
    expect(page).to have_content(@bestsellers.last.author.firstname)
    expect(page).to have_content(@bestsellers.last.author.lastname)
    click_link('Prev')
    expect(page).to have_content(@bestsellers[1].title)
    expect(page).to have_content(@bestsellers[1].description)
    expect(page).to have_content(@bestsellers[1].price)
    expect(page).to have_content(@bestsellers[1].author.firstname)
    expect(page).to have_content(@bestsellers[1].author.lastname)
    click_link('1')
    expect(page).to have_content(@bestsellers.first.title)
    expect(page).to have_content(@bestsellers.first.description)
    expect(page).to have_content(@bestsellers.first.price)
    expect(page).to have_content(@bestsellers.first.author.firstname)
    expect(page).to have_content(@bestsellers.first.author.lastname)
  end

  it 'when click home' do
    click_link('Home')
    expect(page).to have_current_path(root_path)
  end

  it 'when click shop' do
    click_link('Shop')
    expect(page).to have_current_path(books_path)
  end

  it 'when click cart' do
    click_link('Cart')
    expect(page).to have_current_path(order_items_path)
  end

  it 'when click sign in' do
    click_link('Sign in')
    expect(page).to have_current_path(new_customer_session_path)
  end

  it 'when click sign up' do
    click_link('Sign up')
    expect(page).to have_current_path(new_customer_registration_path)
  end

  it 'can add item to cart' do
    find(:xpath, "//li[@aria-hidden='false']").fill_in('order_item_quantity',with: '2')
    find(:xpath, "//li[@aria-hidden='false']").click_button('Add to cart')
    expect(find('.header')).to have_content(@bestsellers.first.price * 2)
    expect(find('.header')).to have_content(2)
  end
end