require "active_support/notifications"

module Proclaimer
  class Configuration
    def subscribe(event_name, callable = Proc.new)
      if callable.respond_to?(:call)
        ActiveSupport::Notifications.subscribe(
          /^spree\.#{Regexp.escape(event_name)}/,
          -> (event, *args, payload) do
            callable.call(event, payload)
          end
        )
      else
        raise \
          ArgumentError,
          "Callback must be a block or object responding to #call."
      end
    end

    def subscribe_all(callable = Proc.new)
      subscribe("", callable)
    end
  end
end
