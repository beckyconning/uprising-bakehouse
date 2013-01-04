class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :address
      t.string :postcode_prefix
      t.string :postcode_suffix
      t.integer :number_of_loaves
      t.integer :customer_id
      t.string :paypal_payer_id
      t.string :paypal_recurring_profile_id
      t.boolean :paypal_recurring_profile_active
      t.datetime :last_payment_date
      t.integer :frequency_in_weeks

      t.timestamps
    end
  end
end
