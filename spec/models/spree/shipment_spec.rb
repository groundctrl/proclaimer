require "spec_helper"

RSpec.describe Spree::Shipment do
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
    let(:shipment) { create(:shipment) }

    before do
      allow(shipment).to receive(:determine_state) { 'ready' }
    end

    it "instruments shipment.ready event" do
      payload = nil

      ActiveSupport::Notifications.subscribed(
        -> (*args) { payload = args.last },
        "spree.shipment.ready"
      ) do
        shipment.ready

        expect(payload[:shipment]).to eq shipment
      end
    end
  end

  context "when shipment is canceled" do
    let(:shipment) { create(:shipment) }

    it "instruments shipment.canceled event" do
      payload = nil

      ActiveSupport::Notifications.subscribed(
        -> (*args) { payload = args.last },
        "spree.shipment.canceled"
      ) do
        shipment.cancel

        expect(payload[:shipment]).to eq shipment
      end
    end
  end
end
