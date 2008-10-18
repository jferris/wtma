class Store < ActiveRecord::Base
  
  validates_presence_of :name, :location, :latitude, :longitude
  
  acts_as_mappable({:lat_column_name => :latitude,
                    :lng_column_name => :longitude,
                    :auto_geocode => {:field => :location}})
  
end
