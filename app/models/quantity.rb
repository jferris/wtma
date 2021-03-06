module Quantity
  def self.quantities
    [ "12 pack",
      "2L",
      "30 pack",
      "6 pack",
      "baker's dozen",
      "bottle",
      "can",
      "carton",
      "container",
      "dozen",
      "family pack",
      "gallon",
      "half dozen",
      "half gallon",
      "jar",
      "jumbo",
      "loaf",
      "package",
      "slice",
      "quart" ]
  end

  def self.filtered(filter)
    quantities.select{|quantity| quantity =~ /^#{filter}/}
  end
end
