module Spree
  Payment.class_eval do
    state_machine.after_transition \
      to: :completed,
      do: :notify_payment_completion

    private

    def notify_payment_completion
      ActiveSupport::Notifications.instrument(
        "spree.payment.complete",
        payment: self
      )
    end
  end
end
