require 'spec_helper'

describe "activations/show.html.erb" do
  before(:each) do
    @activation = assign(:activation, stub_model(Activation,
      :title => "Title",
      :description => "Description",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Description/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/false/)
  end
end
