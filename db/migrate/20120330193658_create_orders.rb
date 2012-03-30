class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.text :address
      t.string :postcode
      t.integer :number_of_loaves

      t.timestamps
    end
  end
end
