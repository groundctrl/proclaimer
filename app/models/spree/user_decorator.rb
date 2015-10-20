module Spree
  User.class_eval do
    after_create :notify_user_create

    private

    def notify_user_create
      ActiveSupport::Notifications.instrument(
        "spree.user.create",
        user: self
      )
    end
  end
end
