require 'spec_helper'

describe "activations/edit.html.erb" do
  before(:each) do
    @activation = assign(:activation, stub_model(Activation,
      :title => "MyString",
      :description => "MyString",
      :active => false
    ))
  end

  it "renders the edit activation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => activation_path(@activation), :method => "post" do
      assert_select "input#activation_title", :name => "activation[title]"
      assert_select "input#activation_description", :name => "activation[description]"
      assert_select "input#activation_active", :name => "activation[active]"
    end
  end
end
