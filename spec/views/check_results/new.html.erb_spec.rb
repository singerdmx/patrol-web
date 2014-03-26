require 'spec_helper'

describe "check_results/new" do
  before(:each) do
    assign(:check_result, stub_model(CheckResult).as_new_record)
  end

  it "renders new check_result form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", check_results_path, "post" do
    end
  end
end
