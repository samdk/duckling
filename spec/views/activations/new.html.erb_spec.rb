require 'spec_helper'

describe "activations/new.html.erb" do
  before(:each) do
    assign(:activation, stub_model(Activation,
      :title => "MyString",
      :description => "MyString",
      :active => false
    ).as_new_record)
  end

  it "renders new activation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => activations_path, :method => "post" do
      assert_select "input#activation_title", :name => "activation[title]"
      assert_select "input#activation_description", :name => "activation[description]"
      assert_select "input#activation_active", :name => "activation[active]"
    end
  end
end
