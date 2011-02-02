require 'spec_helper'

describe Organization do
  
#  it_behaves_like 'soft deletable'
    
  it "should habtm administrators" do
    should have_and_belong_to_many(:administrators)
  end
  
  it 'should have many sections' do
    should have_many(:sections)
  end
  
  it "should habtm managers" do
    should have_and_belong_to_many(:managers)
  end
  
  it "should habtm users" do
    should have_and_belong_to_many(:users)
  end
  
  it "fails validation sans name" do
    should have_at_least(1).error_on(:name)
  end
  
  it "has a name long enough" do
    subject.name = "A"
    should have_at_least(1).error_on(:name)
  end
  
  it "fails validation sans administator" do
    should have_at_least(1).error_on(:administrators)
  end
  
end
