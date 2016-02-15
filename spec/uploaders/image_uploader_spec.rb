require 'carrierwave/test/matchers'

RSpec.describe ImageUploader, :type => :model do
  include CarrierWave::Test::Matchers

  before do
    ImageUploader.enable_processing = true
    @book = create(:book)
    @uploader = ImageUploader.new(@book, :image)
    @uploader.store!(File.open(File.join(Rails.root, '/spec/fixtures/files/image.png')))
  end

  after do
    ImageUploader.enable_processing = false
    @uploader.remove!
  end


  context 'the default version' do
    it 'image to be no larger than 200 by 200 pixels' do
      expect(@uploader).to be_no_larger_than(200, 200)
    end
  end
end