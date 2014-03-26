require 'spec_helper'

describe "check_results/edit" do
  before(:each) do
    @check_result = assign(:check_result, stub_model(CheckResult))
  end

  it "renders the edit check_result form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", check_result_path(@check_result), "post" do
    end
  end
end
