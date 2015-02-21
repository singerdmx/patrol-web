require 'spec_helper'

describe "check_sessions/show" do
  before(:each) do
    @check_session = assign(:check_session, stub_model(CheckSession))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
