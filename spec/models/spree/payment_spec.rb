require "spec_helper"

RSpec.describe Spree::Payment do
  context "when payment is complete" do
    it "instruments payment.complete event" do
      payload = nil

      ActiveSupport::Notifications.subscribed(
        -> (*args) { payload = args.last },
        "spree.payment.complete"
      ) do
        payment = create(:payment)
        payment.complete

        expect(payload[:payment]).to eq payment
      end
    end
  end
end
