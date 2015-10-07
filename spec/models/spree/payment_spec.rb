require "spec_helper"

module Spree
  RSpec.describe Payment, type: :model do
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
end
