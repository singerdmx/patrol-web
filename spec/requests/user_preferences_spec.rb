require 'spec_helper'

describe "UserPreferences" do
  describe "GET /user_preferences" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_preferences_path
      response.status.should be(200)
    end
  end
end
