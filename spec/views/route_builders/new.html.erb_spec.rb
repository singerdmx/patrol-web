require 'spec_helper'

describe "route_builders/new" do
  before(:each) do
    assign(:route_builder, stub_model(RouteBuilder).as_new_record)
  end

  it "renders new route_builder form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", route_builders_path, "post" do
    end
  end
end
