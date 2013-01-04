class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  validates_presence_of :name, :email, :password
  
  has_many :orders, :dependent => :destroy
  
  def order_with_soonest_delivery
    soonest_delivery_order = orders.first
    orders.each do |order|
      if order.next_delivery_date > soonest_delivery_order.next_delivery_date
        soonest_delivery_order = order 
      end
    end
    soonest_delivery_order
  end
end
