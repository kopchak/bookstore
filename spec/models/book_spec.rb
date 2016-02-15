require 'rails_helper'

RSpec.describe Book, :type => :model do
  it { is_expected.to belong_to(:author) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many(:ratings) }
  it { is_expected.to have_many(:order_items) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:stock_qty) }

  context '.bestsellers' do
    before do
      create_list(:book, 10)
      book1 = create(:book)
      book2 = create(:book)
      book3 = create(:book)
      order1 = create(:order, state: 'in_queue')
      order2 = create(:order, state: 'in_delivery')
      order3 = create(:order, state: 'delivered')
      order_item1 = create(:order_item, book_id: book1.id, order_id: order1.id)
      order_item2 = create(:order_item, book_id: book2.id, order_id: order2.id)
      order_item3 = create(:order_item, book_id: book3.id, order_id: order3.id)
      @books = Book.limit(3)
      @bestsellers = Book.bestsellers
    end

    it 'has 3 items' do
      expect(@bestsellers.length).to eq(3)
    end

    it 'returns list of bestsellers' do
      expect(Book.bestsellers).to match_array(@bestsellers)
    end

    it 'bestsellers not to match books' do
      expect(Book.bestsellers).not_to match_array(@books)
    end
  end
end