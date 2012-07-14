require 'spec_helper'

describe 'activations page' do
  let(:password) { 'foobarbazqux' }
  let(:user) { FactoryGirl.create(:user, 
                                  password: password, 
                                  password_confirmation: password) }
  let(:activation) { FactoryGirl.build(:activation) }

  before do
    activation.users << user
    activation.save

  end

  it 'displays the users activations on log in' do
    visit '/login'
    fill_in 'Email', with: user.primary_email_address
    fill_in 'Password', with: password
    
    click_button 'Log In'
    page.should have_content(activation.title)
  end 
end
