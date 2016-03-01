module Cashier
  class Item
    attr_reader :name, :unit, :price, :type, :barcode

    def initialize(name:, unit:, price:, type:, barcode:)
      @name = name
      @unit = unit
      @price = price
      @type = type
      @barcode = barcode
    end
  end
end
