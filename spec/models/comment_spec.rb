require 'spec_helper'

describe Comment do
  
  it "should have a reasonable size" do
    subject.body = '1234' * 1000
    subject.should have_at_least(1).errors_on(:body)
  end
  
  it "can't be blank" do
    should have_at_least(1).errors_on(:body)
  end
  
  it "should belong to an update and a user" do
    subject.should belong_to(:update)
    subject.should belong_to(:author)
  end
  
end
