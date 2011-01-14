require 'spec_helper'

describe "users/index.html.erb" do
  before(:each) do
    pending "working on views"
    assign(:users, [
      stub_model(User,
        :first_name => "First Name",
        :last_name => "Last Name",
        :name_prefix => "Name Prefix",
        :name_suffix => "Name Suffix",
        :phone_numbers => "Phone Numbers"
      ),
      stub_model(User,
        :first_name => "First Name",
        :last_name => "Last Name",
        :name_prefix => "Name Prefix",
        :name_suffix => "Name Suffix",
        :phone_numbers => "Phone Numbers"
      )
    ])
  end

  it "renders a list of users" do
      pending "working on views"
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name Prefix".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name Suffix".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone Numbers".to_s, :count => 2
  end
end
