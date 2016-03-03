require_relative "../lib/cashier"

Cashier.items = {
  "ITEM000001" => Cashier::Item.new(name: "羽毛球", unit: "个", price: 1, type: "体育", barcode: "ITEM000001"),
  "ITEM000003" => Cashier::Item.new(name: "苹果", unit: "斤", price: 5.5, type: "水果", barcode: "ITEM000003"),
  "ITEM000005" => Cashier::Item.new(name: "可口可乐", unit: "瓶", price: 3, type: "饮料", barcode: "ITEM000005")
}

Cashier.promotions = [
  Cashier::Promotion.new(barcode: "ITEM000001", qty: 3) do |info, promoted_items|
    cart_info = cart.items[barcode]
    cart_info[:discounted_total] = cart_info[:price] * (cart_info[:qty] - cart_info[:qty] / qty)
    cart.savings = cart.savings + cart_info[:total] - cart_info[:discounted_total]
    cart.promoted_items[barcode] = cart_info[:qty] / qty
  end,

  Cashier::Promotion.new(barcode: "ITEM000003", qty: 1) do |cart, barcode, qty|
    cart_info = cart.items[barcode]
    cart_info[:discounted_total] = cart_info[:price] * cart_info[:qty] * 0.95
    cart_info[:saving] = cart_info[:total] - cart_info[:discounted_total]
    cart.savings = cart.savings + cart_info[:saving]
  end
]

input = [
  "ITEM000001",
  "ITEM000001",
  "ITEM000001",
  "ITEM000001",
  "ITEM000001",
  "ITEM000003-2",
  "ITEM000005",
  "ITEM000005",
  "ITEM000005"
]

data = Cashier.checkout(input)
Cashier::ReceiptTemplate.new("JZ's Shop", data).print
