require 'spec_helper'

describe "user_preferences/show" do
  before(:each) do
    @user_preference = assign(:user_preference, stub_model(UserPreference))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
