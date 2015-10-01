require "spec_helper"
require "proclaimer"

RSpec.describe Proclaimer do
  describe "configure" do
    it "initialize a configuration object and passing in the block" do
      configuration = double(:configuration)
      given_block = -> {}
      received_block = nil
      allow(Proclaimer::Configuration).
        to receive(:new).and_return(configuration)
      allow(configuration).to receive(:instance_eval) do |&block|
        received_block = block
      end

      Proclaimer.configure(&given_block)

      expect(configuration).to have_received(:instance_eval)
      expect(received_block).to eq given_block
    end
  end
end
