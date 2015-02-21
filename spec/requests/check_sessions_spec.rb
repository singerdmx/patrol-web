require 'spec_helper'

describe "CheckSessions" do
  describe "GET /check_sessions" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get check_sessions_path
      response.status.should be(200)
    end
  end
end
