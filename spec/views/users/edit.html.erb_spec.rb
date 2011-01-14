require 'spec_helper'

describe "users/edit.html.erb" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :first_name => "MyString",
      :last_name => "MyString",
      :name_prefix => "MyString",
      :name_suffix => "MyString",
      :phone_numbers => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_path(@user), :method => "post" do
      assert_select "input#user_first_name", :name => "user[first_name]"
      assert_select "input#user_last_name", :name => "user[last_name]"
      assert_select "input#user_name_prefix", :name => "user[name_prefix]"
      assert_select "input#user_name_suffix", :name => "user[name_suffix]"
      assert_select "input#user_phone_numbers", :name => "user[phone_numbers]"
    end
  end
end
