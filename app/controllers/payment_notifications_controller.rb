class PaymentNotificationsController < ApplicationController
  # POST /payment_notifications
  # POST /payment_notifications.json
  
  protect_from_forgery :except => [:create]
  
  def create
    @payment_notification = PaymentNotification.create!(:params => params, :order_id => params[:invoice], :status => params[:payment_status], :transaction_id => params[:transaction_id])
    render :nothing
  end
end
