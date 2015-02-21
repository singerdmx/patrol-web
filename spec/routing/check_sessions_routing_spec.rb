require "spec_helper"

describe CheckSessionsController do
  describe "routing" do

    it "routes to #index" do
      get("/check_sessions").should route_to("check_sessions#index")
    end

    it "routes to #new" do
      get("/check_sessions/new").should route_to("check_sessions#new")
    end

    it "routes to #show" do
      get("/check_sessions/1").should route_to("check_sessions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/check_sessions/1/edit").should route_to("check_sessions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/check_sessions").should route_to("check_sessions#create")
    end

    it "routes to #update" do
      put("/check_sessions/1").should route_to("check_sessions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/check_sessions/1").should route_to("check_sessions#destroy", :id => "1")
    end

  end
end
