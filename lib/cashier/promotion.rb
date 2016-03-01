module Cashier
  class Promotion
    attr_reader :criteria

    def initialize(barcode:, qty:, &block)
      @barcode = barcode
      @qty = qty
      @block = block
    end

    def can_apply?(items)
      items[key][:qty] && items[key][:qty] >= value
    end

    def apply_to(items)
      block.call(items)
    end
  end
end