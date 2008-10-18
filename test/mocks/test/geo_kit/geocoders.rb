require File.join(RAILS_ROOT, *%w(vendor plugins geokit lib geo_kit geocoders))

module GeoKit
  module Geocoders
    class MultiGeocoder
      def self.geocode(thing)
        returning(GeoLoc.new(:lat => 42.355835, :lng => -71.061849)) do |geoloc|
          geoloc.success = true
        end
      end
    end

    class Geocoder
      def self.geocode(address)
        GeoLoc.new(:lat => 42.355835, :lng => -71.061849)
      end
    end
  end
end
