require "spec_helper"

module Spree
  RSpec.describe OrderUpdater, type: :model do

    describe "#update_shipments_with_status_tracking" do
      it "calls shipment#broadcast on shipments that have changed state" do
        fake_shipments = [
          fake_shipment_with_state("pending", "ready"),
          fake_shipment_with_state("pending")
        ]
        fake_order = double(Order, shipments: fake_shipments)
        updater = described_class.new(fake_order)

        updater.update_shipments

        expect(fake_shipments.first).to have_received(:broadcast_state)
        expect(fake_shipments.last).not_to have_received(:broadcast_state)
      end

      def fake_shipment_with_state(*states)
        spy(Shipment).tap do |shipment|
          allow(shipment).to receive(:state).and_return(*states)
        end
      end
    end
  end
end
