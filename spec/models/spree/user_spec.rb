require "spec_helper"

module Spree
  RSpec.describe User, type: :model do
    context "when user is created" do
      it "instruments user.created event" do
        payload = nil

        ActiveSupport::Notifications.subscribed(
          -> (*args) { payload = args.last },
          "spree.user.created"
        ) do
          user = create(:user)

          expect(payload[:user]).to eq user
        end
      end
    end

    context "when user is updated" do
      it "instruments user.updated event" do
        payload = nil
        user = create(:user)

        ActiveSupport::Notifications.subscribed(
          -> (*args) { payload = args.last },
          "spree.user.updated"
        ) do
          user.save!

          expect(payload[:user]).to eq user
        end
      end
    end
  end
end
