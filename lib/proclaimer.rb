require "spree_core"
require "proclaimer/engine"
require "proclaimer/configuration"

module Proclaimer
  def self.configure(&block)
    Configuration.new.instance_eval(&block)
  end
end
