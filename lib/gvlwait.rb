require "gvlwait/version"
require "gvlwait/engine"
require "gvlwait/gvl_instrumentation_middleware"
require "gvlwait/configuration"

module Gvlwait
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
