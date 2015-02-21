require 'spec_helper'

describe "check_sessions/new" do
  before(:each) do
    assign(:check_session, stub_model(CheckSession).as_new_record)
  end

  it "renders new check_session form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", check_sessions_path, "post" do
    end
  end
end
