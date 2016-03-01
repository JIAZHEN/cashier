require_relative "../lib/cashier"
require "spec_helper"

describe Cashier do
  let(:input) do
    [
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
  end

  let(:items) {{
    "ITEM000001" => Cashier::Item.new(name: "羽毛球", unit: "个", price: 1, type: "体育", barcode: "ITEM000001"),
    "ITEM000003" => Cashier::Item.new(name: "苹果", unit: "斤", price: 5.5, type: "水果", barcode: "ITEM000003"),
    "ITEM000005" => Cashier::Item.new(name: "可口可乐", unit: "瓶", price: 3, type: "饮料", barcode: "ITEM000005")
  }}

  before { Cashier.items = items }

  context "#scan" do
    it "returns empty hash by default" do
      expect(Cashier.scan).to eq({})
    end

    context "when input is provided" do
      let(:result) {{
        "ITEM000001" => { total: 5, qty: 5, price: 1 },
        "ITEM000003" => { total: 11, qty: 2, price: 5.5 },
        "ITEM000005" => { total: 9, qty: 3, price: 3 }
      }}

      it "groups input with barcode and counts" do
        expect(Cashier.scan(input)).to eq result
      end
    end
  end

end
