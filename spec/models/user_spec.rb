require 'spec_helper'

def make_user(first, last, cheating = false)
  u = User.new(first_name: first, last_name: last,
    password: 'password', password_confirmation: 'password',
    initial_email: "#{first[0]}#{last}@example.com")
  u.instance_variable_set :@cheating, true if cheating
  u.save
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
  
  context "two buddies" do
    before :each do      
      @u  = make_user 'Bob', 'Smith', true
      @u2 = make_user 'Jane', 'Smith', true
      @u.reload
      @u2.reload
    end
    
    it 'should not have them acquainted by default' do
      @u.acquaintances.should == []
      @u2.acquaintances.should == []
    end
    
    it 'should acquaint them correctly' do
      @u.acquaintances << @u2
      
      @u2.acquainted_to?(@u).should be_true
      @u.acquainted_to?(@u2).should be_true
    end
    
    it 'should not make duplicates' do
      3.times { @u.ensure_acquaintances @u2 }
      3.times { @u2.ensure_acquaintances @u }
      
      @u.acquaintances(true).size.should == 1
      @u2.acquaintances(true).size.should == 1
    end
    
    it 'should unacquaint them correctly' do
      @u.ensure_acquaintances @u2      
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
  
  context "for credentialing" do
    before :each do
      subject.first_name = 'John'
      subject.last_name = 'Smith'
      subject.password = subject.password_confirmation = 'password'
      subject.save
      
      subject.authorize_with(subject).add_email 'foo@example.com'
      subject.authorize_with(subject).add_email 'bar@example.com'
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
