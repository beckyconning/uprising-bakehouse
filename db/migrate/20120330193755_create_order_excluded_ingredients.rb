class CreateOrderExcludedIngredients < ActiveRecord::Migration
  def change
    create_table :order_excluded_ingredients do |t|
      t.integer :order_id
      t.integer :ingredient_id

      t.timestamps
    end
  end
end
