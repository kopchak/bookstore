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
    # before do
    #   book1 = create(:book)
    #   book2 = create(:book)
    #   book3 = create(:book)
    #   order1 = create(:order)
    #   order2 = create(:order)
    #   order3 = create(:order)
    #   order_item1 = create(:order_item, book_id: book1.id, order_id: order1.id)
    #   order_item2 = create(:order_item, book_id: book2.id, order_id: order2.id)
    #   order_item3 = create(:order_item, book_id: book3.id, order_id: order3.id)
    #   create_list(:book, 10)
    #   create_list(:order, 10, state: 'in_progress')
    #   create_list(:order_item, 10, book_id: book1.id)
    #   @books = Book.all
    #   @bestsellers = Book.bestsellers
    # end

    it 'has 3 items' do
      # book = create(:book)
      # expect(@bestsellers.length).to eq(3)
      # byebug
    end

    it 'bla' do
      # expect(@bestsellers).not_to match_array(@books)
    end
  end
  # add for mount uploader Image
end