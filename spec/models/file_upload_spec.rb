require 'spec_helper'

describe FileUpload do
  it 'should limit file name length' do
    subject.upload_file_name = 'a'*200
    subject.should have_at_least(1).errors_on(:upload_file_name)
  end
end
