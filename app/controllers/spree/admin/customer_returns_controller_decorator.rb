module Spree
  module Admin
    CustomerReturnsController.class_eval do
      create.after :notify_subscribers_on_successful_create

      private

      def notify_subscribers_on_successful_create
        ActiveSupport::Notifications.instrument(
          "spree.customer_return.create",
          customer_return: @object
        )
      end
    end
  end
end
