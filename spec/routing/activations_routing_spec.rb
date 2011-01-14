require "spec_helper"

describe ActivationsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/activations" }.should route_to(:controller => "activations", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/activations/new" }.should route_to(:controller => "activations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/activations/1" }.should route_to(:controller => "activations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/activations/1/edit" }.should route_to(:controller => "activations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/activations" }.should route_to(:controller => "activations", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/activations/1" }.should route_to(:controller => "activations", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/activations/1" }.should route_to(:controller => "activations", :action => "destroy", :id => "1")
    end

  end
end
