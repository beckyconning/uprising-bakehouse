class PaymentNotification < ActiveRecord::Base
  belongs_to :order
  serialize :params
  after_create :set_order_recurring_profile_status, :set_last_payment_date
  
  private
  def set_order_recurring_profile_status
    order.paypal_recurring_profile_active = (params[:profile_status] == "ActiveProfile")
  end
  
  def set_last_payment_date
    order.last_payment_date = Time.zone.now if status == "Completed"
  end
end
