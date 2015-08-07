require "spec_helper"

RSpec.describe Spree::Admin::CustomerReturnsController do
  stub_authorization!

  describe "POST #create" do
    let(:order) { create(:shipped_order) }
    let(:inventory_unit) { order.inventory_units.first }
    let(:return_item) { create(:return_item, inventory_unit: inventory_unit) }
    let(:return_authorization) {
      create(:return_authorization, order: order, return_items: [return_item])
    }
    let(:stock_location) { create(:stock_location) }

    it "sends a notification with customer_return as a payload" do
      payload = nil

      ActiveSupport::Notifications.
        subscribe("spree.customer_return.create") do |*args|
        payload = args.last
      end

      spree_post \
        :create,
        order_id: order.to_param,
        customer_return: {
          stock_location_id: stock_location.id,
          return_items_attributes: {
            "0" => {
              id: return_item.id,
              returned: "1",
              pre_tax_amount: "10.00",
              inventory_unit_id: inventory_unit.id
            }
          }
        }

      expect(payload[:customer_return]).to eq Spree::CustomerReturn.last
    end
  end
end
