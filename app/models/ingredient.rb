class Ingredient < ActiveRecord::Base
  has_many :order_excluded_ingredients
  has_many :orders, :through => :order_excluded_ingredient
end
