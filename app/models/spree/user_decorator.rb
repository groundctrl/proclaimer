module Spree
  User.class_eval do
    after_create { notify_user_event(:created) }
    after_update { notify_user_event(:updated) }

    private

    def notify_user_event(event)
      ActiveSupport::Notifications.instrument(
        "spree.user.#{event}",
        user: self
      )
    end
  end
end
