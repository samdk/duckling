require 'spec_helper'

describe Group, Section do
  
  it 'should have a reasonably short name' do
    subject.name = 'A' * 51
    subject.should have_at_least(1).errors_on(:name)
  end
  
  it 'should have a reasonably short description' do
    subject.description = 'A' * 1001
    subject.should have_at_least(1).errors_on(:description)
  end
  
  it 'should require a name' do
    should have_at_least(1).errors_on(:name)
  end
  
  it 'should not require a description' do
    should have(0).errors_on(:descrption)
  end
  
end
