require 'spec_helper'

describe Organization do
  
  it_behaves_like 'soft deletable'
    
  it "should have administrators" do
    should have_many(:administrators)
  end
  
  it "should have managers" do
    should have_many(:managers)
  end
  
  it "should have users" do
    should have_many(:users)
  end
  
  it "fails validation sans name" do
    should have(1).error_on(:name)
  end
  
  it "fails validation sans administator" do
    should have(1).error_on(:administrators)
  end
  
end
