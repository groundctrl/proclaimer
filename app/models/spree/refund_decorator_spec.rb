module Spree
  Refund.class_eval do
    after_create :notify_refund_processed

    private

    def notify_refund_processed
      ActiveSupport::Notifications.instrument(
        "spree.refund.complete",
        refund: self
      )
    end
  end
end
