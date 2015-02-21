require 'spec_helper'

describe "check_sessions/edit" do
  before(:each) do
    @check_session = assign(:check_session, stub_model(CheckSession))
  end

  it "renders the edit check_session form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", check_session_path(@check_session), "post" do
    end
  end
end
