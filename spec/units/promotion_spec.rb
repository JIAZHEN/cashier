require "spec_helper"

describe Cashier::Promotion do
  let(:barcode) { "ITEM000001" }
  let(:threshold) { 3 }
  let(:promotion) do
    described_class.new(barcode: barcode, qty: threshold) do |info, promoted_items, promotion|
      promoted_items[promotion.barcode] = info[:qty] / promotion.qty
      info[:total] = info[:price] * (info[:qty] - info[:qty] / promotion.qty)
    end
  end

  context "#can_apply?" do
    context "when barcode does not match" do
      it "returns false" do
        expect(promotion.can_apply?("NOT MATCHED", {})).to eq false
      end
    end

    context "when quantity is nil" do
      it "returns false" do
        expect(promotion.can_apply?(barcode, {})).to eq false
      end
    end

    context "when quantity is less than promotion threshold" do
      let(:qty) { threshold - 1 }

      it "returns false" do
        expect(promotion.can_apply?(barcode, { qty: qty })).to eq false
      end
    end

    context "when quantity is over" do
      let(:qty) { threshold + 1 }

      it "returns false" do
        expect(promotion.can_apply?(barcode, { qty: qty })).to eq true
      end
    end
  end

  context "#apply_to" do
    let(:info) {{ qty: 7, price: 1 }}
    let(:promoted_items) { {} }
    let(:expected_info) { { qty: 7, price: 1, total: 5 } }
    let(:expected_promoted_items) { { barcode => 2 } }

    it "apply the promotion to info" do
      promotion.apply_to(info, promoted_items)
      expect(info).to eq expected_info
      expect(promoted_items).to eq expected_promoted_items
    end
  end
end
