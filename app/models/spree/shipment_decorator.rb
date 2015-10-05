module Spree
  Shipment.class_eval do
    after_create :notify_shipment_pending
    state_machine.after_transition to: :ready, do: :notify_shipment_ready
    state_machine.after_transition to: :canceled, do: :notify_shipment_canceled

    private

    %i(pending ready canceled).each do |type|
      define_method(:"notify_shipment_#{type}") { notification_event type }
    end

    def notification_event(type)
      ActiveSupport::Notifications.instrument(
        "spree.shipment.#{type}",
        shipment: self
      )
    end
  end
end
