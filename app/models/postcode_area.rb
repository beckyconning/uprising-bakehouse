class PostcodeArea < ActiveRecord::Base
  has_many :orders, :foreign_key => 'postcode_prefix', :primary_key => 'postcode_prefix', :order => "address DESC"
  
  def self.delivery_days
    PostcodeArea.all.collect { |postcode_area|
      postcode_area.delivery_day
    }.uniq
  end
  
end
