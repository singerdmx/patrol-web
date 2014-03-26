require 'spec_helper'

describe "check_results/index" do
  before(:each) do
    assign(:check_results, [
      stub_model(CheckResult),
      stub_model(CheckResult)
    ])
  end

  it "renders a list of check_results" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
