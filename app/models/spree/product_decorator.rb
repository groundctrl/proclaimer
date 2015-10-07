module Spree
  Product.class_eval do
    after_save :broadcast_changes, if: :anything_changed?

    private

    def broadcast_changes
      ActiveSupport::Notifications.instrument(
        "spree.product.updated",
        product: self
      )
    end
  end
end
