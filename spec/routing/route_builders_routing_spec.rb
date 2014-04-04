require "spec_helper"

describe RouteBuildersController do
  describe "routing" do

    it "routes to #index" do
      get("/route_builders").should route_to("route_builders#index")
    end

    it "routes to #new" do
      get("/route_builders/new").should route_to("route_builders#new")
    end

    it "routes to #show" do
      get("/route_builders/1").should route_to("route_builders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/route_builders/1/edit").should route_to("route_builders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/route_builders").should route_to("route_builders#create")
    end

    it "routes to #update" do
      put("/route_builders/1").should route_to("route_builders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/route_builders/1").should route_to("route_builders#destroy", :id => "1")
    end

  end
end
