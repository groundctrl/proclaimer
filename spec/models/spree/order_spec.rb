require "spec_helper"

RSpec.describe Spree::Order do
  before { stub_const("EMPTY_PAYLOAD", Object.new) }

  context "when order is first created" do
    it "does not instrument any order event" do
      payload = EMPTY_PAYLOAD

      ActiveSupport::Notifications.subscribed(
        -> (*args) { payload = args.last },
        /^spree\.order/
      ) do
        create(:order)

        expect(payload).to eq EMPTY_PAYLOAD
      end
    end
  end

  context "when order is complete" do
    it "instruments order.complete event" do
      payload = EMPTY_PAYLOAD

      ActiveSupport::Notifications.subscribed(
        -> (*args) { payload = args.last },
        "spree.order.complete"
      ) do
        order = create(:order_with_line_items, state: "confirm")
        create(:payment, amount: order.total, order: order)
        order.next!

        expect(payload[:order]).to eq order
      end
    end
  end
end
