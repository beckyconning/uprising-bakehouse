class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  before_filter :get_customer_and_order_and_authenticate
  def index
    if staff_member_signed_in?
      sign_out(current_customer) if customer_signed_in?
      
      @user_type = "staff_member"
      
      @orders = Order.select { |o| o.has_delivery_this_week }
      
      get_grouped_orders
      
      @postcode_areas = @orders.collect { |o| o.postcode_area }.uniq
      
      @current_order_index = 0
    elsif customer_signed_in?
      @customer = current_customer
      @user_type = "customer"
      @orders = @customer.orders
    else
      redirect_to root_path
    end
    
    if @orders.count == 0 then
      respond_to do |format|
        format.html { redirect_to new_order_path }
        format.json { render json: @orders }
      end
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @orders }
      end
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = @customer.orders.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = @customer.orders.new(params[:order])

    respond_to do |format|
      if @order.save_or_create_interest
        format.html { redirect_to @order }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    respond_to do |format|
      params[:order][:number_of_loaves] = @order.number_of_loaves
      params[:order][:frequency_in_weeks] = @order.frequency_in_weeks
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
  
  def checkout
    redirect_to @order.paypal.checkout_url(
      return_url: finish_order_url(@order),
      cancel_url: root_url,
      ipn_url:    payment_notification_url
    )
  end
  
  def finish
    if params[:PayerID]
      @order.paypal_payer_id = params[:PayerID]
      @order.paypal_payment_token = params[:token]
    end
    if @order.save_with_billing
      redirect_to root_path, :notice => "Thank you! Your order has been placed. Your first delivery will be on #{@order.first_delivery_date}."      
      sign_out(current_customer)
    else
      render :new
    end
  end
  
  private
  def get_customer_and_order_and_authenticate
    @customer = current_customer
    if params[:id]
      @order = Order.find(params[:id])
      unless @order.customer == @customer || current_staff_member
        redirect_to root_path, :notice => "You can only access your own orders."
      end
    end
  end
  
  def get_grouped_orders
    if params[:group_index_combinations] == nil || params[:commit] == "Reset"
      @grouped_orders = Order.grouped_by_excluded_ingredients(@orders)
      @group_index_combinations = {}
    elsif params[:group_index_combinations]
      @group_index_combinations = params[:group_index_combinations]
      @grouped_orders = Order.merged_excluded_ingredient_groups(
        :grouped_orders => Order.grouped_by_excluded_ingredients(@orders),
        :group_index_combinations => params[:group_index_combinations]
      )
    
    end
  end
end
