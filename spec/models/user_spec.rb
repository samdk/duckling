require 'spec_helper'

describe User do
  
  it_behaves_like 'soft deletable'

  it "should have many organizations" do
    should have_many(:organizations)
  end
  
  it "can be the administrator of many organizations" do
    should have_many(:administrated_organizations)
  end
  
  it "can be the manager of many organizations" do
    should have_many(:managed_organizations)
  end
  
  it "has many email addresses" do
    should have_many(:email_addresses)
  end
  
  it "should update its password hash securely" do
    should have(1).error_on(:password_hash)
    
    subject.password = 'sahana123'
    
    its(:password) { should == 'sahana123' }
    should have(0).errors_on(:password_hash)
    
    @user2 = User.new
    @user2.password = 'sahana123'
    @user2.password_hash.should_not == subject.password_hash
  end
  
  it "should assemble names correctly" do
    should have(1).error_on(:first_name)
    should have(1).error_on(:last_name)
    
    u = User.new first_name: 'John', last_name: 'Smith'
    u.name.should == 'John Smith'
    
    u.name_prefix = 'Dr.'
    u.name.should == 'Dr. John Smith'
  
    u.name_suffix = 'Jr'
    u.name.should == 'Dr. John Smith Jr'
    
    u.name_prefix = nil
    u.name.should == 'John Smith Jr'
  end
  
  it "should serialize phone numbers" do
    should serialize(:phone_numbers, as: Hash)
  end
  
  it "should reformat phone numbers" do
    subject.phone_numbers['home'] = '5855551234'
    subject.phone_numbers['cell'] = '(585) 555-4321'
    subject.should have(2).phone_numbers

    subject.save(false)    
    subject.phone_numbers['home'].should == '+15855551234'
    subject.phone_numbers['cell'].should == '+15855554321'
  end

end
