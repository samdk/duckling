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
end
