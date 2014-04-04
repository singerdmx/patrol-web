require 'spec_helper'

describe "route_builders/show" do
  before(:each) do
    @route_builder = assign(:route_builder, stub_model(RouteBuilder))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
