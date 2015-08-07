require "spec_helper"

RSpec.describe Spree::Admin::ReimbursementsController do
  stub_authorization!

  describe "POST #create" do
    let(:customer_return) { create(:customer_return_with_accepted_items) }
    let(:order) { customer_return.order }

    it "sends a notification with reimbursement as a payload" do
      payload = nil

      ActiveSupport::Notifications.
        subscribe("spree.reimbursement.create") do |*args|
        payload = args.last
      end

      spree_post \
        :create,
        order_id: order.to_param,
        build_from_customer_return_id: customer_return.id

      expect(payload[:reimbursement]).to eq Spree::Reimbursement.first
    end
  end
end
