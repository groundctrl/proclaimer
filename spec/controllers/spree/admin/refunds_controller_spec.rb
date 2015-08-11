require "spec_helper"

RSpec.describe Spree::Admin::RefundsController do
  stub_authorization!

  describe "POST #create" do
    let(:payment) { create(:payment, amount: 10.00) }
    let(:refund_reason) { create(:refund_reason) }

    it "sends a notification with refund as a payload" do
      payload = nil

      ActiveSupport::Notifications.subscribe("spree.refund.create") do |*args|
        payload = args.last
      end

      spree_post \
        :create,
        refund: { amount: "10.00", refund_reason_id: refund_reason.to_param },
        order_id: payment.order.to_param,
        payment_id: payment.to_param

      expect(payload[:refund]).to eq Spree::Refund.last
    end
  end
end
