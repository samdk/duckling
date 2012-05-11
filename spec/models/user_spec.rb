require 'spec_helper'

# TODO: check rcov

def make_user(first, last, cheating = false)
  u = User.new(first_name: first, last_name: last)
  u.password = u.password_confirmation = 'password'
  u.instance_variable_set :@cheating, true if cheating
  u.save
  u.add_email "#{first[0]}#{last}@example.com", true
  u
end

describe User do
  
  it_behaves_like 'an authorized model', ->(*){ make_user 'John', 'Smith' }

  context "for preventing cheating" do
    it 'should stop mass-assignment' do
      unsafe = { reset_token: 'abcd', state: 'abcd', password_hash: 'abcd',
          cookie_token: 'abcd', api_token: 'abcd',
          primary_email_id: 1, cookie_token_expires_at: Time.now,
          created_at: Time.now, updated_at: Time.now, deleted_at: Time.now,
          avatar_updated_at: Time.now}
        
      u = User.new
      
      before_attributes = unsafe.keys.inject({}) {|h,k| h[k] = u.send(k) ; h }
      
      u.attributes = unsafe
        
      for key in unsafe.keys
        u.send(key).should == before_attributes[key]
      end
    end
  end
  
  context "two amigos" do
    before :each do      
      @u  = make_user 'Bob', 'Smith', true
      @u2 = make_user 'Jane', 'Smith', true
      @u.reload
      @u2.reload
    end
    
    it 'should assign em correctly' do
      @u.acquaintances << @u2
      
      @u2.acquainted_to?(@u).should be_true
      @u.acquainted_to?(@u2).should be_true
    end
    
    it 'should remove em correctly' do
      @u.acquaintances << @u2      
      @u.acquaintances.clear
      
      @u.acquaintances(true).should  == []
      @u2.acquaintances(true).should == []
    end
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
  
  it "should reformat phone numbers" do
    subject.phone_numbers['home'] = '5855551234'
    subject.phone_numbers['cell'] = '(585) 555-4321'
    subject.should have(2).phone_numbers

    subject.save(validate: false)    
    subject.phone_numbers['home'].should == '585-555-1234'
    subject.phone_numbers['cell'].should == '585-555-4321'
  end
  
  context "for credentialing" do
    before :each do
      subject.first_name = 'John'
      subject.last_name = 'Smith'
      subject.password = subject.password_confirmation = 'password'
      subject.save
      
      subject.add_email('foo@example.com', true)
      subject.add_email('bar@example.com', true)
    end

    it 'should credential either email address' do
      User.with_credentials('foo@example.com', 'password').should == subject
      User.with_credentials('bar@example.com', 'password').should == subject      
    end
    
    it 'should be case agnostic' do
      User.with_credentials('BAR@EXAmplE.Com', 'password').should == subject
    end
    
    it 'should deny other email addresses' do
      User.with_credentials('qux@example.com', 'password').should be_false
    end
    
    it 'should deny bad passwords' do
      User.with_credentials('foo@example.com', 'PaSsWoRd').should be_false
    end
  end

end
