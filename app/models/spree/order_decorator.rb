module Spree
  Order.class_eval do
    state_machine.after_transition to: :complete, do: :notify_order_completion

    private

    def notify_order_completion
      ActiveSupport::Notifications.instrument(
        "spree.order.complete",
        order: self
      )
    end
  end
end
