require 'gvltools'
require 'net/http'
require 'uri'
require 'concurrent'

module Gvlwait
  class GvlInstrumentationMiddleware
    BATCH_SIZE = 100
    @@gvl_wait_durations = Concurrent::Array.new

    def initialize(app)
      @app = app
      raise "GvlInstrumentationMiddleware requires Puma as the web server. Other servers are not supported." unless defined?(Puma)
      GVLTools::LocalTimer.enable
    end

    def call(env)
      gvl_start_time = GVLTools::LocalTimer.monotonic_time
      request_start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond)

      response = @app.call(env)

      gvl_wait_duration_ms = ((GVLTools::LocalTimer.monotonic_time - gvl_start_time) / 1_000_000.0).round(2)
      total_request_duration_ms = Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond) - request_start_time
      
      @@gvl_wait_durations << gvl_wait_duration_ms

      if @@gvl_wait_durations.size >= BATCH_SIZE
        log_gvl_wait_duration_data
      end

      response
    end

    private

      def log_gvl_wait_duration_data
        values_to_send = @@gvl_wait_durations.dup
        @@gvl_wait_durations.clear
        
        Gvlwait::RecordDurationsJob.perform_later(values_to_send, "web", puma_max_threads)
      end

      def puma_max_threads
        @_puma_max_threads ||= JSON.parse(Puma.stats)["max_threads"]
      end
  end
end
