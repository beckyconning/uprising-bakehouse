class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :address
      t.string :postcode
      t.integer :number_of_loaves
      t.integer :customer_id
      t.string :paypal_token
      t.string :paypal_profile_id

      t.timestamps
    end
  end
end
