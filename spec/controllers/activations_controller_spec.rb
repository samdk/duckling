require 'spec_helper'

describe ActivationsController do
  let(:user) { stub_model(User) }

  before do
    controller.stub(:current_user) { user }
  end

  describe 'GET index' do
    it 'responds with success' do
      get :index
      response.should be_success
    end
  end
end
