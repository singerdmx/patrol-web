require 'spec_helper'

describe "check_results/show" do
  before(:each) do
    @check_result = assign(:check_result, stub_model(CheckResult))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
