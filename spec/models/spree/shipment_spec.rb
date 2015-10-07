require "spec_helper"

module Spree
  RSpec.describe Shipment, type: :model do
    context "when shipment is pending" do
      it "instruments shipment.pending event" do
        payload = nil

        ActiveSupport::Notifications.subscribed(
          -> (*args) { payload = args.last },
          "spree.shipment.pending"
        ) do
          shipment = create(:shipment)

          expect(payload[:shipment]).to eq shipment
        end
      end
    end

    context "when shipment is ready" do
      it "instruments shipment.ready event" do
        shipment = create(:shipment)
        allow(shipment).to receive(:determine_state) { 'ready' }
        allow(ActiveSupport::Notifications).to receive(:instrument)

        shipment.ready

        expect(ActiveSupport::Notifications).
          to have_received(:instrument).
          with("spree.shipment.ready", shipment: shipment)
      end
    end

    context "when shipment is canceled" do
      it "instruments shipment.canceled event" do
        shipment = create(:shipment)
        allow(ActiveSupport::Notifications).to receive(:instrument)

        shipment.cancel

        expect(ActiveSupport::Notifications).
          to have_received(:instrument).
          with("spree.shipment.canceled", shipment: shipment)
      end
    end

    describe "#broadcast_state" do
      it "instruments shipment.STATE event" do
        shipment = build(:shipment, state: 'pending')
        allow(ActiveSupport::Notifications).to receive(:instrument)

        shipment.broadcast_state

        expect(ActiveSupport::Notifications).
          to have_received(:instrument).
          with("spree.shipment.pending", shipment: shipment)
      end
    end
  end
end

