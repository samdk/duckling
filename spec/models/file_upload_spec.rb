require 'spec_helper'

describe FileUpload do
  it 'should belong to an update' do
    should belong_to(:update)
  end
end
