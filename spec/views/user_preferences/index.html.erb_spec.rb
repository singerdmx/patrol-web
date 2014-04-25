require 'spec_helper'

describe "user_preferences/index" do
  before(:each) do
    assign(:user_preferences, [
      stub_model(UserPreference),
      stub_model(UserPreference)
    ])
  end

  it "renders a list of user_preferences" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
