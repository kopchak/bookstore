require 'rails_helper'

describe "Customer do", js: true do
  before do
    # @customer = create(:customer)
  end

  it "can sign in" do
    @customer = create(:customer)
    visit(new_customer_session_path)
    fill_in('your email', with: @customer.email)
    fill_in('password', with: @customer.password)
    click_button('Sign in')
    expect(page).to have_current_path(root_path)
    expect(page).to have_link('Settings')
    expect(page).to have_link('Orders')
    expect(page).to have_link('Sign out')
  end

  it 'can sign up' do
    visit(new_customer_registration_path)
    fill_in( 'your email', with: Faker::Internet.email )
    fill_in( 'password', with: Faker::Internet.password(8) )
    click_button('Sign up')
    expect(page).to have_current_path(root_path)
    expect(page).to have_link('Settings')
    expect(page).to have_link('Orders')
    expect(page).to have_link('Sign out')
  end
end
