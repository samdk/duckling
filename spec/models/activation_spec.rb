require 'spec_helper'

describe Activation do
  
  it_behaves_like 'soft deletable', ->(*){ Activation.cheating_create!(title: 'Foo Bar') }
  it_behaves_like 'an authorized model', -> { Activation.cheating_create(title: 'Activation') }
  
  it 'must have a title' do
    subject.should have_at_least(1).errors_on(:title)
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
