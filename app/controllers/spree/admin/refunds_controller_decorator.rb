module Spree
  module Admin
    RefundsController.class_eval do
      create.after :notify_subscribers_on_successful_refund

      private

      def notify_subscribers_on_successful_refund
        ActiveSupport::Notifications.instrument(
          "spree.refunds.create",
          refund: @object
        )
      end
    end
  end
end
