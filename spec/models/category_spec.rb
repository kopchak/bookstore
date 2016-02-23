require 'rails_helper'

RSpec.describe Category, :type => :model do
  it { is_expected.to have_many(:books) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:title) }

  context '.has_book' do
    before do
      category1 = create(:category)
      category2 = create(:category)
      category3 = create(:category)
      book1 = create(:book, category_id: category1.id)
      book2 = create(:book, category_id: category2.id)
      @categories = Category.all
      @categories_has_books = Category.has_book
    end

    it 'has 2 items' do
      expect(@categories_has_books.length).to eq(2)
    end

    it 'returns list of categories_has_books' do
      expect(Category.has_book).to match_array(@categories_has_books)
    end

    it 'categories_has_books not to match array categories' do
      expect(Category.has_book).not_to match_array(@categories)
    end
  end
end