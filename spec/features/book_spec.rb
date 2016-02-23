require 'rails_helper'

describe "Customer do", js: true do
  before do
    create(:book)
    @first_book = Book.first
  end

  it 'when sign in, can add review' do
    @customer = create(:customer)
    login_as(@customer)
    click_link(@first_book.title)
    page.save_screenshot('screenshot.png')
  end
end