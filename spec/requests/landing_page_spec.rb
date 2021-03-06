require 'spec_helper'

describe 'activations page' do
  let(:password) { 'foobarbazqux' }
  let(:user) { FactoryGirl.create(:user, 
                                  password: password, 
                                  password_confirmation: password) }
  let(:activation) { FactoryGirl.create(:activation) }
  let(:other_activation) { FactoryGirl.create(:activation) }

  before do
    activation.memberships.create(user: user)
    FactoryGirl.build_list(:update, 3, activation: activation)
    activation.users.should include(user)
  end

  it 'displays the users activations' do
    visit '/login'
    fill_in 'Email', with: user.primary_email_address
    fill_in 'Password', with: password
    click_button 'Log In'
    visit overview_url
    click_link 'Activations'

    page.should have_content(activation.title)
    page.should_not have_content(other_activation.title)
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
