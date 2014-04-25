require 'spec_helper'

describe "user_preferences/edit" do
  before(:each) do
    @user_preference = assign(:user_preference, stub_model(UserPreference))
  end

  it "renders the edit user_preference form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_preference_path(@user_preference), "post" do
    end
  end
end
