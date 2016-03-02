module Cashier
  class Promotion
    attr_reader :barcode, :qty

    def initialize(barcode:, qty:, &block)
      @barcode = barcode
      @qty = qty
      @block = block
    end

    def can_apply?(cart)
      cart.items[barcode][:qty] && cart.items[barcode][:qty] >= qty
    end

    def apply_to(cart)
      @block.call(cart, barcode, qty)
    end
  end
end