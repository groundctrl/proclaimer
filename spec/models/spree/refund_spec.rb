require "spec_helper"

describe Spree::Refund do
  before { stub_const("EMPTY_PAYLOAD", Object.new) }

  context "when refund have not been processed" do
    it "does not instrument any refund event" do
      payload = EMPTY_PAYLOAD

      ActiveSupport::Notifications.subscribed(
        -> (*args) { payload = args.last },
        /^spree\.refund/
      ) do
        build(:refund)

        expect(payload).to eq EMPTY_PAYLOAD
      end
    end
  end

  context "when the refund has been processed" do
    it "instruments refund.complete event" do
      payload = EMPTY_PAYLOAD

      ActiveSupport::Notifications.subscribed(
        -> (*args) { payload = args.last },
        "spree.refund.complete"
      ) do
        refund = create(:refund, payment: create(:payment, amount: 100))

        expect(payload[:refund]).to eq refund
      end
    end
  end
end
