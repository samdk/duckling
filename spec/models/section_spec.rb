require 'spec_helper'

describe Section do
  it 'should habtm users' do
    should have_and_belong_to_many(:users)
  end
end
