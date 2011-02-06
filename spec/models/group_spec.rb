require 'spec_helper'

describe Group, Section do
  it 'should have and belong to many users' do
    should have_and_belong_to_many(:users)
  end
  
  it 'should belong to groupable' do
    should belong_to(:groupable)
  end
  
  it 'should have a reasonably short name' do
    subject.name = 'A' * 100
    subject.should have_at_least(1).errors_on(:name)
  end
  
  it 'should have a reasonably short description' do
    subject.description = 'A' * 100
    subject.should have_at_least(1).errors_on(:description)
  end
  
  it 'should require a name but not a description' do
    should have_at_least(1).errors_on(:name)
    should have(0).errors_on(:descrption)
  end
  
  
end
