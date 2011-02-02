require 'spec_helper'

describe Activation do
  
#  it_behaves_like 'soft deletable'

  it 'should have many organizations' do
    should have_many(:organizations)
  end
  
  it 'should have many updates' do
    should have_many(:updates)
  end
  
end
