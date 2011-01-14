require 'spec_helper'

describe "activations/index.html.erb" do
  before(:each) do
    assign(:activations, [
      stub_model(Activation,
        :title => "Title",
        :description => "Description",
        :active => false
      ),
      stub_model(Activation,
        :title => "Title",
        :description => "Description",
        :active => false
      )
    ])
  end

  it "renders a list of activations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
