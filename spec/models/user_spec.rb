require 'spec_helper'

describe User do
  
  # it_behaves_like 'soft deletable'

  it "should have many organizations" do
    should have_many(:organizations)
  end
  
  it "can be the administrator of many organizations" do
    should have_many(:administrated_organizations)
  end
  
  it "can be the manager of many organizations" do
    should have_many(:managed_organizations)
  end
  
  it "should update its password hash securely" do
    should have(1).error_on(:password_hash)
    
    subject.password = 'sahana123'
    
    subject.password.should == 'sahana123'
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
  
  it 'should serialize email addresses' do
    should serialize(:email_addresses, as: Array)
  end
  
  it "should reformat phone numbers" do
    subject.phone_numbers['home'] = '5855551234'
    subject.phone_numbers['cell'] = '(585) 555-4321'
    subject.should have(2).phone_numbers

    subject.save(validate: false)    
    subject.phone_numbers['home'].should == '+15855551234'
    subject.phone_numbers['cell'].should == '+15855554321'
  end
  
  context "for credentialing" do
    before(:all) do
      subject.first_name = 'John'
      subject.last_name = 'Smith'
      subject.password = 'abc123'
      subject.email_addresses << 'foo@example.com'
      subject.email_addresses << 'bar@example.com'
      subject.save
    end
    
    it 'should be saved' do
      subject.changed?.should be_false
    end
    
    it 'should credential either email address' do
      User.credentials?('bar@example.com', 'abc123').should be_true
      User.credentials?('foo@example.com', 'abc123').should be_true
    end
    
    it 'should deny other email addresses' do
      User.credentials?('qux@example.com', 'abc123').should be_false
    end
    
    it 'should deny bad passwords' do
      User.credentials?('foo@example.com', 'ABC123').should be_false
    end
  end

end
