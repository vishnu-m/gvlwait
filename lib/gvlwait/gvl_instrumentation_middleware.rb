require 'gvltools'
require 'net/http'
require 'uri'
require 'concurrent'

module Gvlwait
  class GvlInstrumentationMiddleware
    BATCH_SIZE = 100
    @@metrics = Concurrent::Array.new

    def initialize(app)
      @app = app
      raise "GvlInstrumentationMiddleware requires Puma as the web server. Other servers are not supported." unless defined?(Puma)
      GVLTools::LocalTimer.enable
    end

    def call(env)
      gvl_start_time = GVLTools::LocalTimer.monotonic_time
      request_start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond)

      response = @app.call(env)

      gvl_wait_time_ms = ((GVLTools::LocalTimer.monotonic_time - gvl_start_time) / 1_000_000.0).round(2)
      request_processing_time_ms = Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond) - request_start_time
      
      metric = {
        request_id: env["action_dispatch.request_id"],
        process_type: "web",
        gvl_wait_time: gvl_wait_time_ms,
        processing_time: request_processing_time_ms,
        concurrency_level: puma_max_threads
      }

      @@metrics << metric

      if @@metrics.size >= BATCH_SIZE
        record_request_metrics
      end

      response
    end

    private

      def record_request_metrics
        metrics_to_send = @@metrics.dup
        @@metrics.clear
        
        Gvlwait::RecordMetricsJob.perform_later(metrics_to_send)
      end

      def puma_max_threads
        @_puma_max_threads ||= JSON.parse(Puma.stats)["max_threads"]
      end
  end
end
