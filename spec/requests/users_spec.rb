require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    it "works! (now write some real specs)" do
      get '/users'
      response.status.should == 404
    end
  end
end
