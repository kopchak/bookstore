require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
  context "GET #index" do
    before do
      get :index
    end

    it "renders the #index view" do
      expect(response).to render_template(:index)
    end
  end
end