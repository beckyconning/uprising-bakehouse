class PaypalPayment
  def initialize(order)
    @order = order
  end
  
  def make_recurring
    #process :request_payment
    process(
      :create_recurring_profile, 
      period: "Week", 
      frequency: @order.frequency_in_weeks, 
      start_at: @order.first_delivery_date
    )
  end
  
  def checkout_details
    process :checkout_details
  end
  
  def checkout_url(options)
    process(:checkout, options).checkout_url
  end
  
  def process(action, options = {})
    weeks_noun = @order.frequency_in_weeks == 1 ? "week" : "weeks"
    options = options.reverse_merge(
      failed: "1",
      token: @order.paypal_payment_token,
      payer_id: @order.paypal_payer_id,
      description: 
        "Uprising Bakehouse Bread Club order for #{@order.number_of_loaves.to_s}
        delicious loaves every #{@order.frequency_in_weeks} #{weeks_noun}. Total cost: #{@order.price} GBP per delivery.",
      amount: @order.price,
      currency: "GBP"
    )
    response = PayPal::Recurring.new(options).send(action)
    raise response.errors.inspect if response.errors.present?
    response
  end
end