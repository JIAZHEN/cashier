require_relative "../lib/cashier"

Cashier.items = {
  "ITEM000001" => Cashier::Item.new(name: "羽毛球", unit: "个", price: 1, type: "体育", barcode: "ITEM000001"),
  "ITEM000003" => Cashier::Item.new(name: "苹果", unit: "斤", price: 5.5, type: "水果", barcode: "ITEM000003"),
  "ITEM000005" => Cashier::Item.new(name: "可口可乐", unit: "瓶", price: 3, type: "饮料", barcode: "ITEM000005")
}

# ITEM000001 has two promotions
Cashier.promotions = [
  Cashier::Promotion.new(barcode: "ITEM000001", qty: 1) do |info, promoted_items, promotion|
    info[:total] = info[:price] * info[:qty] * 0.95
    info[:saving] = info[:price] * info[:qty] * 0.05
  end,

  Cashier::Promotion.new(barcode: "ITEM000001", qty: 3) do |info, promoted_items, promotion|
    promoted_items[promotion.barcode] = info[:qty] / promotion.qty
    info[:total] = info[:price] * (info[:qty] - info[:qty] / promotion.qty)
  end,

  Cashier::Promotion.new(barcode: "ITEM000003", qty: 1) do |info, promoted_items, promotion|
    info[:total] = info[:price] * info[:qty] * 0.95
    info[:saving] = info[:price] * info[:qty] * 0.05
  end,

  Cashier::Promotion.new(barcode: "ITEM000005", qty: 3) do |info, promoted_items, promotion|
    promoted_items[promotion.barcode] = info[:qty] / promotion.qty
    info[:total] = info[:price] * (info[:qty] - info[:qty] / promotion.qty)
  end
]

input = [
  "ITEM000005",
  "ITEM000005",
  "ITEM000005",
  "ITEM000001",
  "ITEM000001",
  "ITEM000001",
  "ITEM000001",
  "ITEM000001",
  "ITEM000001",
  "ITEM000003-2"
]

data = Cashier.checkout(input)
Cashier::ReceiptTemplate.new("JZ's Shop", data).print
