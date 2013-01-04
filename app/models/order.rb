class Order < ActiveRecord::Base
  has_many :order_excluded_ingredients
  has_many :excluded_ingredients, :through => :order_excluded_ingredients, :source => :ingredient
  belongs_to :customer
  belongs_to :postcode_area, :foreign_key => 'postcode_prefix', :primary_key => 'postcode_prefix'
  
  attr_accessor :paypal_payment_token
  
  validates_presence_of :number_of_loaves, :on => :create, :message => "can't be blank"
  validates_presence_of :frequency_in_weeks, :on => :create, :message => "can't be blank"
  validate :postcode_must_have_space, :order_frequency_and_amount_valid
  
  before_destroy :cancel_recurring_billing
  
  def self.grouped_by_excluded_ingredients(orders = Order.all)
    puts orders.inspect
    unique_excluded_ingredient_combinations = orders.collect { |o| o.excluded_ingredients }.uniq
    grouped_orders = unique_excluded_ingredient_combinations.collect do |eic|
     orders.select { |o| o.excluded_ingredients == eic }
    end
    grouped_orders.uniq
  end
  
  def self.merged_excluded_ingredient_groups(options = {})
    groups_of_orders = options[:grouped_orders]
    puts "groups of orders: #{groups_of_orders}"
    puts "group indexes: " + options[:group_index_combinations].inspect
    options[:group_index_combinations].each_value do |group_index_combination|
      first_index = group_index_combination[0].to_i
      group_index_combination[1..-1].each do |index|
        index = index.to_i
        puts "combining #{first_index} and #{index}"
        groups_of_orders[first_index] = groups_of_orders[first_index].to_a + groups_of_orders[index].to_a
        groups_of_orders[index] = "delete"
      end
      groups_of_orders.delete("delete")
    end
    groups_of_orders
  end
  
  
  def self.all_excluded_ingredients(orders = Order.all)
    orders.collect{ |o|
      o.excluded_ingredients.collect{ |ei| ei }
    }.flatten.uniq
  end
  
  def self.excluded_ingredients_list(ingredients)
    ingredients.collect{ |ei| ei.name }.join(", ")
  end
  
  def postcode=(postcode)
    postcode_segments = postcode.downcase.split(" ")
    
    self.postcode_prefix = postcode_segments[0]
    postcode_area = PostcodeArea.find_by_postcode_prefix(postcode_segments[0])
    
    self.postcode_suffix = postcode_segments[1]
  end
  
  def postcode
    "#{postcode_prefix} #{postcode_suffix}"
  end
  
  def excluded_ingredients_list
    Order.excluded_ingredients_list(excluded_ingredients)
  end
  
  def payment_provided?
    paypal_recurring_profile_id != nil
  end
  
  def paypal
    PaypalPayment.new(self)
  end
  
  def save_with_billing
    if valid?
      response = paypal.make_recurring
      self.paypal_recurring_profile_id = response.profile_id
      save!
    end
  end
  
  def cancel_recurring_billing
    ppr = PayPal::Recurring.new(:profile_id => paypal_recurring_profile_id)
    ppr.cancel
    paypal_recurring_profile_id = nil
    save!
  end
  
  def billing_started
    if paypal_recurring_profile_id
      return true
    end
  end
  
  def first_delivery_date
    Date.next_day_from_date(delivery_day, created_at.to_date + 1.day)
  end

  def next_delivery_date
    next_delivery_date_from(Date.today)
  end
  
  def previous_delivery_date
    next_delivery_date_from(Date.today) - frequency_in_weeks.weeks
  end
  
  def has_delivery_this_week
    weeks_until_next_delivery == 0
  end
  
  def weeks_until_next_delivery
    weeks_until_next_delivery_from(Date.next(delivery_day))
  end
  
  def next_delivery_day_for_postcode(date = Date.today)
    Date.next_day_from_date(delivery_day, date)
  end
  
  def weeks_until_next_delivery_from(date)
    weeks_since_first_delivery = ((first_delivery_date - next_delivery_day_for_postcode).to_i) / 7
    weeks_until_next_delivery = (weeks_since_first_delivery % frequency_in_weeks)
  end
  
  def next_delivery_date_from(date)
    return next_delivery_day_for_postcode + weeks_until_next_delivery_from(date)
  end
  
  def delivery_day
    return postcode_area.delivery_day
  end
  
  def price
    pennies = (number_of_loaves * APP_CONFIG['loaf_price']) + APP_CONFIG['delivery_price']
    pennies / 100
  end
  
  def save_or_create_interest
    if we_deliver_to_postcode
      save
    else
      InterestInPostcodeArea.create(:postcode_prefix => postcode_prefix)
      errors.add(:base, 
        "Sorry we can't deliver to #{postcode_prefix.upcase}. We've noted that you tried to order and if enough people 
        from your area express an interest in our Bread Club then we will extend our deliveries to your area. 
        Thanks so much for trying to join our Bread Club!")
      return false
    end
  end
  
  private
  def we_deliver_to_postcode
    PostcodeArea.find_by_postcode_prefix(postcode_prefix)
  end

  
  def order_frequency_and_amount_valid
    if number_of_loaves && frequency_in_weeks
      unless number_of_loaves > 0 &&  frequency_in_weeks > 0
        errors.add(:base, "Please ensure you are ordering at least 1 loaf a year")
      end
    end
  end
  
  def postcode_must_have_space
    unless postcode.include?(" ")
      errors.add(:base, "Please type your postcode with a space in the middle")
    end
  end
end
