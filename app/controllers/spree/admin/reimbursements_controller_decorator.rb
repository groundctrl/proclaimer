module Spree
  module Admin
    ReimbursementsController.class_eval do
      create.after :notify_subscribers_on_successful_create

      private

      def notify_subscribers_on_successful_create
        ActiveSupport::Notifications.instrument(
          "spree.reimbursement.create",
          reimbursement: @object
        )
      end
    end
  end
end
