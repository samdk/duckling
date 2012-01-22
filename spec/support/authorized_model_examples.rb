require 'spec_helper'

shared_examples 'an authorized model' do |model_proc|
  
  before :each do
    @model = model_proc.call
  end
  
  it 'should implicitly deny updating' do
    expect {
      @model.save(validate: false)
    }.to raise_error(Unauthorized)
  end
  
  it 'should implicity deny destruction' do
    expect { @model.destroy }.to raise_error(Unauthorized)
    @model.destroyed?.should be_false
  end
  
  xit 'should implicity prevent reads' do
    expect { @model.class.find(model.id) }.to raise_error(Unauthorized)
  end
end
