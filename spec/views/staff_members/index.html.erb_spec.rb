require 'spec_helper'

describe "staff_members/index" do
  before(:each) do
    assign(:staff_members, [
      stub_model(StaffMember,
        :name => "Name",
        :email_address => "Email Address"
      ),
      stub_model(StaffMember,
        :name => "Name",
        :email_address => "Email Address"
      )
    ])
  end

  it "renders a list of staff_members" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email Address".to_s, :count => 2
  end
end
