require 'gvltools'
require 'net/http'
require 'uri'
require 'concurrent'

module Gvlwait
  class GvlInstrumentationMiddleware
    BATCH_SIZE = 100
    @@gvl_wait_times = Concurrent::Array.new

    def initialize(app)
      @app = app
      GVLTools::LocalTimer.enable
    end

    def call(env)
      gvl_start_time = GVLTools::LocalTimer.monotonic_time
      request_start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond)

      response = @app.call(env)

      gvl_wait_duration_ms = ((GVLTools::LocalTimer.monotonic_time - gvl_start_time) / 1_000_000.0).round(2)
      total_request_duration_ms = Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond) - request_start_time
      
      @@gvl_wait_times << gvl_wait_duration_ms

      if @@gvl_wait_times.size >= BATCH_SIZE
        log_gvl_wait_time_data
      end

      response
    end

    def log_gvl_wait_time_data
      values_to_send = @@gvl_wait_times.dup
      @@gvl_wait_times.clear

      values_to_send.each do |gvl_wait_time|
        puts "[Gvlwait] gvl_wait_time=#{gvl_wait_time}"
        # TODO -- Persist this information
      end
    end
  end
end
