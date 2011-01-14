require 'spec_helper'

describe "users/show.html.erb" do

  before(:each) do
    @user = assign(:user, stub_model(User,
      :first_name => "First Name",
      :last_name => "Last Name",
      :name_prefix => "Name Prefix",
      :name_suffix => "Name Suffix"
    ))
  end

  it "renders attributes in <p>" do
    pending "working on views"
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Last Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name Prefix/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name Suffix/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone Numbers/)
  end
end
