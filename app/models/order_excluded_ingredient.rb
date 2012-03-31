class OrderExcludedIngredient < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :order
end
