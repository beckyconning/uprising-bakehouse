require 'spec_helper'

describe "orders/edit" do
  before(:each) do
    @order = assign(:order, stub_model(Order,
      :address => "MyText",
      :postcode => "MyString",
      :number_of_loaves => 1
    ))
  end

  it "renders the edit order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => orders_path(@order), :method => "post" do
      assert_select "textarea#order_address", :name => "order[address]"
      assert_select "input#order_postcode", :name => "order[postcode]"
      assert_select "input#order_number_of_loaves", :name => "order[number_of_loaves]"
    end
  end
end
