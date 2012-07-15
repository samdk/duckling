require 'spec_helper'

describe 'activations page' do
  let(:password) { 'foobarbazqux' }
  let(:user) { FactoryGirl.create(:user, 
                                  password: password, 
                                  password_confirmation: password) }
  let(:activation) { FactoryGirl.create(:activation_with_updates, member: user) }

  before do
    activation.users.should include(user)
    activation.updates.should_not be_empty
  end

  it 'displays the users activations on log in' do
    visit '/login'
    fill_in 'Email', with: user.primary_email_address
    fill_in 'Password', with: password
    click_button 'Log In'
    visit overview_url

    click_link 'Activations'
    page.should have_content(activation.title)
  end 

  it 'displays updates for an activation' do
    visit '/login'
    fill_in 'Email', with: user.primary_email_address
    fill_in 'Password', with: password
    click_button 'Log In'
    visit overview_url

    click_link 'Activations'
    click_link activation.title
    page.should have_content("#{activation.updates.count} updates")
    page.should have_content(activation.updates.first.title)
  end 
end
