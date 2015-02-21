require 'spec_helper'

describe "check_sessions/index" do
  before(:each) do
    assign(:check_sessions, [
      stub_model(CheckSession),
      stub_model(CheckSession)
    ])
  end

  it "renders a list of check_sessions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
