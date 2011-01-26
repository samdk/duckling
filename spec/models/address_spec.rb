require 'spec_helper'

describe Address do
  it 'should belony to a user' do
    should belong_to(:user)
  end
  
  it 'should preserve multi-line formatting' do
    addr = "123 Fake Street\nMiddletown, NY 05281" 
    Address.create(name: 'Work', address: addr)   
    Address.where(name: 'Work').first.address.should == addr
  end
  
  it 'should strip lines' do
    addr = " 123 Fake Street\n    Middletown, NY 05281   "
    Address.create(name: 'Work', address: addr)   
    Address.where(name: 'Work').first.address.should == addr.split("\n").map(&:strip).join("\n")
  end
  
  it 'should not allow really long addresses' do
    a = Address.new(name: 'Foo', address: 'asdf'*1000)
    a.should have_at_least(1).errors_on(:address)
  end
  
  it 'should require a name' do
    should have_at_least(1).errors_on(:name)
  end
  
  it 'should require an address' do
    should have_at_least(1).errors_on(:address)
  end
end
