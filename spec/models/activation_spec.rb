require 'spec_helper'

describe Activation do
  
  context "with a saved subject" do
    before :each do
      subject.update_attributes title: 'Test Title'
    end
    
    it_behaves_like 'soft deletable'
  end

  it 'should have many organizations' do
    should have_and_belong_to_many(:organizations)
  end
  
  it 'should have many updates' do
    should have_many(:updates)
  end
  
  it 'must have a title' do
    should have_at_least(1).errors_on(:title)
  end
  
  it 'must have a reasonably sized title' do
    subject.title = 'ADSF ' * 100
    subject.should have_at_least(1).errors_on(:title)
    
    subject.title = ' '
    subject.should have_at_least(1).errors_on(:title)
  end
  
  it 'must remember when it is made active' do
    subject.activate
    subject.active_since.should < Time.now
    subject.active_since.should > Time.now - 10.seconds
  end
  
  it 'must remember when it is made inactive' do
    subject.deactivate
    subject.inactive_since.should < Time.now
    subject.inactive_since.should > Time.now - 10.seconds
  end
  
end
