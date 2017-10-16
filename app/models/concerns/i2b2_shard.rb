require 'active_support/concern'

module I2b2Shard

  extend ActiveSupport::Concern

  included do

    octopus_establish_connection(Octopus.config[Rails.env][:i2b2])

    allow_shard :i2b2

    def self.inherited(child)
      child.octopus_establish_connection Octopus.config[Rails.env][:i2b2]
      super
    end

    def readonly?
      true
    end
  end
end
