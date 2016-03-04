require 'rails_helper'

describe "Facebook_omniauth", js: true do
  context 'sign in' do
    it 'bla' do
      visit(new_customer_session_path)
      find('.facebook_image').click
      expect(page).to have_current_path(root_path)
      expect(page).to have_content(I18n.t('home.header.sign_out_link'))
    end
  end

  context 'sign up' do
    it 'bla' do
      visit(new_customer_registration_path)
      find('.facebook_image').click
      expect(page).to have_current_path(root_path)
      expect(page).to have_content(I18n.t('home.header.sign_out_link'))
    end
  end
end
