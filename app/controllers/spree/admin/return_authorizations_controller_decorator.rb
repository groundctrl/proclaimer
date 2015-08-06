module Spree
  module Admin
    ReturnAuthorizationsController.class_eval do
      create.after :notify_subscribers_on_successful_create

      private

      def notify_subscribers_on_successful_create
        ActiveSupport::Notifications.instrument(
          "spree.return_authorization.create",
          return_authorization: @object
        )
      end
    end
  end
end
