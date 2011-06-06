require 'spec_helper'

describe Update do
  
  it 'should require an author' do
    should have_at_least(1).errors_on(:author)
  end
  
  it 'should require title and body' do
    should have_at_least(1).errors_on(:title)
    should have_at_least(1).errors_on(:body)
  end
  
  it 'should impose reasonable limits' do
    subject.title = 'a' * 129
    subject.body  = 'a' * 100_001
    subject.should have_at_least(1).errors_on(:title)
    should have_at_least(1).errors_on(:body)
  end
  
end
