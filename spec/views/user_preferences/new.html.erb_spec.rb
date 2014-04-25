require 'spec_helper'

describe "user_preferences/new" do
  before(:each) do
    assign(:user_preference, stub_model(UserPreference).as_new_record)
  end

  it "renders new user_preference form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_preferences_path, "post" do
    end
  end
end
