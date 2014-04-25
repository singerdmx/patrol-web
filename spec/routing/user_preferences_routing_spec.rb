require "spec_helper"

describe UserPreferencesController do
  describe "routing" do

    it "routes to #index" do
      get("/user_preferences").should route_to("user_preferences#index")
    end

    it "routes to #new" do
      get("/user_preferences/new").should route_to("user_preferences#new")
    end

    it "routes to #show" do
      get("/user_preferences/1").should route_to("user_preferences#show", :id => "1")
    end

    it "routes to #edit" do
      get("/user_preferences/1/edit").should route_to("user_preferences#edit", :id => "1")
    end

    it "routes to #create" do
      post("/user_preferences").should route_to("user_preferences#create")
    end

    it "routes to #update" do
      put("/user_preferences/1").should route_to("user_preferences#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/user_preferences/1").should route_to("user_preferences#destroy", :id => "1")
    end

  end
end
