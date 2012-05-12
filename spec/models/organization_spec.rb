require 'spec_helper'

describe Organization do
  
  it_behaves_like 'soft deletable', ->(*){ Organization.cheating_create!(name: 'Foobar') }
  it_behaves_like 'an authorized model', ->(*){ Organization.create(name: 'Foobar') }
    
  it "fails validation sans name" do
    should have_at_least(1).error_on(:name)
  end
  
  it "has a name long enough" do
    subject.name = "A"
    should have_at_least(1).error_on(:name)
  end
  
  it "fails validation sans administator" do
    subject.name = 'asdf'
    subject.save
    
    should have_at_least(1).error_on(:administrators)
  end
  
  
  context 'checking permissions' do
    let :user do
      User.create first_name: 'John',
                  last_name: 'Smith',
                  password: 'password',
                  password_confirmation: 'password',
                  initial_email: 'jsmith@example.com'
    end

    it 'should allow creation by default' do
      user.can?(create: Organization.new).should be_true
    end
    
    it 'should claim to deny by default for read, update, destroy' do
      for action in [:read, :update, :destroy]
        user.can?(action => subject).should be_false
      end
    end
  end
  
end
