module Cashier
  class Promotion
    attr_reader :barcode, :qty

    def initialize(barcode:, qty:, &block)
      @barcode = barcode
      @qty = qty
      @block = block
    end

    def can_apply?(barcode, info)
      barcode == self.barcode && info[:qty] && info[:qty] >= qty
    end

    def apply_to(info, promoted_items)
      @block.call(info, promoted_items, self)
    end
  end
end