Module Cashier
  class Item
    def initialize(name:, unit:, price:, type:, barcode:)
      @name = name
      @unit = unit
      @price = price
      @type = type
      @barcode = barcode
    end
  end
end
