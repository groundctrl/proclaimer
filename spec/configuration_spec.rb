require "spec_helper"
require "proclaimer/configuration"

RSpec.describe Proclaimer::Configuration do
  before do
    stub_const "PAYLOAD", Object.new
  end

  after do
    ActiveSupport::Notifications.unsubscribe(/^spree\./)
  end

  describe "#subscribe" do
    context "subscription" do
      it "supports subscribing to an event with given event name" do
        event_name = nil
        payload = nil

        configuration.subscribe("order.complete") do |*args|
          event_name = args.first
          payload = args.second
        end

        trigger_event "spree.order.complete", PAYLOAD

        expect(event_name).to eq "spree.order.complete"
        expect(payload).to eq PAYLOAD
      end

      it "supports subscribing to any event starting with given string" do
        event_name = nil
        payload = nil

        configuration.subscribe("order") do |*args|
          event_name = args.first
          payload = args.second
        end

        trigger_event "spree.order.complete", PAYLOAD

        expect(event_name).to eq "spree.order.complete"
        expect(payload).to eq PAYLOAD
      end
    end

    context "callable" do
      it "raises error if the given object does not respond to call" do
        expect { configuration.subscribe("event", :nope) }.
          to raise_error(ArgumentError, /call/)
      end
    end
  end

  describe "#subscribe_all" do
    context "subscription" do
      it "subscribe to all spree events" do
        event_name = nil
        payload = nil

        configuration.subscribe_all do |*args|
          event_name = args.first
          payload = args.second
        end

        trigger_event "spree.order.complete", PAYLOAD

        expect(event_name).to eq "spree.order.complete"
        expect(payload).to eq PAYLOAD
      end

      it "does not subscribe to non-spree event" do
        event_name = nil
        payload = nil

        configuration.subscribe_all do |*args|
          event_name = args.first
          payload = args.second
        end

        trigger_event "some.other.event", {}

        expect(event_name).to be_nil
        expect(payload).to be_nil
      end
    end

    context "callable" do
      it "raises error if the given object does not respond to call" do
        expect { configuration.subscribe_all(:nope) }.
          to raise_error(ArgumentError, /call/)
      end
    end
  end

  def configuration
    Proclaimer::Configuration.new
  end

  def trigger_event(event_name, payload)
    ActiveSupport::Notifications.instrument(event_name, payload)
  end
end
