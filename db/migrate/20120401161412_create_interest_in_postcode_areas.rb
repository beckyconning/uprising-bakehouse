class CreateInterestInPostcodeAreas < ActiveRecord::Migration
  def change
    create_table :interest_in_postcode_areas do |t|
      t.string :postcode_prefix

      t.timestamps
    end
  end
end
