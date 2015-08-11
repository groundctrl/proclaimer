module Spree
  module Admin
    ResourceController.class_eval do
      def self.inherited(subclass)
        super
        subclass.create.after :notify_subscribers_on_successful_create
      end

      private

      def notify_subscribers_on_successful_create
        ActiveSupport::Notifications.instrument(
          "spree.#{resource.object_name}.create",
          resource.object_name.to_sym => @object
        )
      end
    end
  end
end
