require 'spec_helper'

describe "staff_members/edit" do
  before(:each) do
    @staff_member = assign(:staff_member, stub_model(StaffMember,
      :name => "MyString",
      :email_address => "MyString"
    ))
  end

  it "renders the edit staff_member form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => staff_members_path(@staff_member), :method => "post" do
      assert_select "input#staff_member_name", :name => "staff_member[name]"
      assert_select "input#staff_member_email_address", :name => "staff_member[email_address]"
    end
  end
end
