require 'spec_helper'

describe "route_builders/edit" do
  before(:each) do
    @route_builder = assign(:route_builder, stub_model(RouteBuilder))
  end

  it "renders the edit route_builder form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", route_builder_path(@route_builder), "post" do
    end
  end
end
