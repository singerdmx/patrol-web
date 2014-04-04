require 'spec_helper'

describe "route_builders/index" do
  before(:each) do
    assign(:route_builders, [
      stub_model(RouteBuilder),
      stub_model(RouteBuilder)
    ])
  end

  it "renders a list of route_builders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
