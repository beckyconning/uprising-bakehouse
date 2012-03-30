require 'spec_helper'

describe "orders/index" do
  before(:each) do
    assign(:orders, [
      stub_model(Order,
        :address => "MyText",
        :postcode => "Postcode",
        :number_of_loaves => 1
      ),
      stub_model(Order,
        :address => "MyText",
        :postcode => "Postcode",
        :number_of_loaves => 1
      )
    ])
  end

  it "renders a list of orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Postcode".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
