class Store < ActiveRecord::Base
  cattr_accessor :nearby_miles

  has_many :purchases
  
  validates_presence_of :name, :location, :latitude, :longitude
  
  acts_as_mappable :lat_column_name => :latitude,
                   :lng_column_name => :longitude
end
