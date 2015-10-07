require "spec_helper"

module Spree
  RSpec.describe Product, type: :model do
    context "when changes are present" do
      it "instruments spree.product.updated event" do
        product = build_product

        product.run_callbacks(:save)

        expect(ActiveSupport::Notifications).
          to have_received(:instrument).
          with("spree.product.updated", product: product)
      end
    end

    context "when no changes are present" do
      it "instruments spree.product.updated event" do
        product = build_product
        allow(product).to receive(:anything_changed?) { false }

        product.run_callbacks(:save)

        expect(ActiveSupport::Notifications).
          not_to have_received(:instrument).
          with("spree.product.updated", product: product)
      end
    end

    def build_product
      build(:product).tap do
        allow(ActiveSupport::Notifications).to receive(:instrument)
      end
    end
  end
end
