module Spree
  OrderUpdater.class_eval do
    def update_shipments_with_state_tracking
      shipment_states = shipments.map(&:state)
      update_shipments_without_state_tracking

      shipments.each_with_index do |shipment, index|
        shipment.broadcast_state if shipment_states[index] != shipment.state
      end
    end

    alias_method_chain :update_shipments, :state_tracking
  end
end
