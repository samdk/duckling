require 'spec_helper'

describe 'overview page' do
  let(:password) { 'foobarbazqux' }
  let(:user) { FactoryGirl.create(:user, 
                                  password: password, 
                                  password_confirmation: password) }

  let(:activation) { FactoryGirl.create(:activation) }
  let(:other_activation) { FactoryGirl.create(:activation) }

  let(:organization) { FactoryGirl.create(:organization) }
  let(:other_organization) { FactoryGirl.create(:organization) }

  before do
    organization.memberships.create(user: user)
    activation.memberships.create(user: user)
    activation.users.should include(user)
  end

  it 'displays the users activations and organizations' do
    visit '/login'
    fill_in 'Email', with: user.primary_email_address
    fill_in 'Password', with: password
    click_button 'Log In'
    visit overview_url

    page.should have_content(activation.title)
    page.should_not have_content(other_activation.title)

    page.should have_content(organization.name)
    page.should_not have_content(other_organization.name)
  end 
end
