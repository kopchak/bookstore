require 'rails_helper'

RSpec.describe Customers::OmniauthCallbacksController, :type => :controller do
  context '#facebook' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:customer]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    end

    it 'after sign in, create session' do
      expect(session).to be_empty
      get :facebook
      expect(session).not_to be_empty
      expect(session['flash']['flashes']['notice']).to eq("Successfully authenticated from Facebook account.")
    end

    it "should redirect to root" do
      get :facebook
      expect(response).to redirect_to root_path
    end
  end

  context 'when no valid user data' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:customer]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:empty]
    end

    it 'bla' do
      get :facebook
      expect(response).to redirect_to new_customer_registration_url
    end
  end
end