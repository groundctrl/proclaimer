require "spec_helper"

module Spree
  RSpec.describe User, type: :model do
    before { stub_const("EMPTY_PAYLOAD", Object.new) }

    context "when user is created" do
      it "instruments user.create event" do
        payload = EMPTY_PAYLOAD

        ActiveSupport::Notifications.subscribed(
          -> (*args) { payload = args.last },
          "spree.user.create"
        ) do
          user = create(:user)

          expect(payload[:user]).to eq user
        end
      end
    end

    context "when user is updated" do
      it "does not instrument any user event" do
        payload = EMPTY_PAYLOAD
        user = create(:user)

        ActiveSupport::Notifications.subscribed(
          -> (*args) { payload = args.last },
          /^spree\.user/
        ) do
          user.save!

          expect(payload).to eq EMPTY_PAYLOAD
        end
      end
    end
  end
end
