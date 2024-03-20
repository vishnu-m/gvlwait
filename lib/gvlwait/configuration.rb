module Gvlwait
  class Configuration
    attr_accessor :puma_max_threads

    def initialize
      @puma_max_threads = nil
    end
  end
end
