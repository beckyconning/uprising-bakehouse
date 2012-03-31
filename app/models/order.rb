class Order < ActiveRecord::Base
  has_many :order_excluded_ingredients
  has_many :excluded_ingredients, :through => :order_excluded_ingredients, :source => :ingredient
  belongs_to :customer
  
  def pay
    ppr = PayPal::Recurring.new({
      :amount      => APP_CONFIG['bread_price'] * self.number_of_loaves,
      :currency    => "USD",
      :description => "Awesome - Monthly Subscription",
      :ipn_url     => "http://example.com/paypal/ipn",
      :frequency   => 1,
      :token       => "EC-05C46042TU8306821",
      :period      => :monthly,
      :reference   => "1234",
      :payer_id    => "WTTS5KC2T46YU",
      :start_at    => Time.now,
      :failed      => 1,
      :outstanding => :next_billing
    })
  end
end
