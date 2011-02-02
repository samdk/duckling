require 'spec_helper'

describe Group do
  it 'should have and belong to many users' do
    should have_and_belong_to_many(:users)
  end
end
