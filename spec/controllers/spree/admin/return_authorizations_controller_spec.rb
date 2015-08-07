require "spec_helper"

RSpec.describe Spree::Admin::ReturnAuthorizationsController do
  stub_authorization!

  describe "POST #create" do
    let(:order) { create(:shipped_order) }
    let(:shipment) { order.shipments.first }
    let(:inventory_unit) { order.inventory_units.first }
    let(:return_authorization_reason) { create(:return_authorization_reason) }

    it "sends a notification with return_authorization as a payload" do
      payload = nil

      ActiveSupport::Notifications.
        subscribe("spree.return_authorization.create") do |*args|
        payload = args.last
      end

      spree_post \
        :create,
        order_id: order.to_param,
        return_authorization: {
          stock_location_id: shipment.stock_location.to_param,
          return_authorization_reason_id: return_authorization_reason.to_param,
          return_items_attributes: {
            0 => {
              inventory_unit_id: inventory_unit.to_param,
              pre_tax_amount: shipment.pre_tax_amount.to_s
            }
          }
        }

      expect(payload[:return_authorization]).
        to eq Spree::ReturnAuthorization.last
    end
  end
end
