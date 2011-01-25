require 'spec_helper'

describe "users/new.html.erb" do
  
  pending "working on views"
  before(:each) do
    assign(:user, stub_model(User,
      :first_name => "MyString",
      :last_name => "MyString",
      :name_prefix => "MyString",
      :name_suffix => "MyString"
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_first_name", :name => "user[first_name]"
      assert_select "input#user_last_name", :name => "user[last_name]"
      assert_select "input#user_name_prefix", :name => "user[name_prefix]"
      assert_select "input#user_name_suffix", :name => "user[name_suffix]"
      assert_select "input#user_phone_numbers", :name => "user[phone_numbers]"
    end
  end
end
