require 'spec_helper'

describe Update do
  
  it 'should belong to poster and to activation' do
    should belong_to(:user)
    should belong_to(:activation)
  end
  
  it 'should require a number of things' do
    should have_at_least(1).errors_on(:title)
    should have_at_least(1).errors_on(:body)
  end
  
  it 'should impose reasonable limits' do
    subject.title = 'a' * 51
    subject.body = "asdf" * 10000
    subject.should have_at_least(1).errors_on(:title)
    should have_at_least(1).errors_on(:body)
  end
  
end
