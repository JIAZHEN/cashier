require_relative "../lib/cashier"
require "spec_helper"

describe Cashier::Cart do
  let(:cart) { described_class.new }

  context "#match?" do
    context "when promotion is nil" do
      let(:promotion) { nil }

      it "returns false" do
        expect(cart.match?(promotion)).to eq false
      end
    end

    context "when doesn't match the promotion" do
      let(:promotion) do
        Cashier::Promotion.new("ITEM000001" => 2) do |cart|
          cart.items["ITEM000001"][:qty] - 1
        end
      end

      it "returns false" do
        expect(cart.match?(promotion)).to eq false
      end
    end
  end

  context "#print" do
    context "when cart is empty" do
      let(:receipt_for_empty) do
<<-eos
***<My Shop商店>购物清单***
总计：0.00(元)
**********************
eos
      end

      it "prints the receipt for empty" do
        expect(cart.print).to eq receipt_for_empty
      end
    end
  end
end
