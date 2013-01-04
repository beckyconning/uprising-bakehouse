class CreatePostcodeAreas < ActiveRecord::Migration
  def change
    create_table :postcode_areas do |t|
      t.string :postcode_prefix
      t.string :delivery_day
      t.string :name

      t.timestamps
    end
  end
end
