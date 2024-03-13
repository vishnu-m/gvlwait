require 'gvltools'
require 'net/http'
require 'uri'
require 'rufus-scheduler'
require 'concurrent'

module Gvlwait
  class GvlInstrumentationMiddleware
    @@gvl_wait_times = Concurrent::Array.new
    @@scheduler = Rufus::Scheduler.new

    def initialize(app)
      @app = app
      GVLTools::LocalTimer.enable

      @@scheduler.every '30s' do
        log_gvl_wait_time_data unless @@gvl_wait_times.empty?
      end
    end

    def call(env)
      gvl_start_time = GVLTools::LocalTimer.monotonic_time
      request_start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond)

      response = @app.call(env)

      gvl_wait_duration_ms = ((GVLTools::LocalTimer.monotonic_time - gvl_start_time) / 1_000_000.0).round(2)
      total_request_duration_ms = Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_millisecond) - request_start_time
      
      @@gvl_wait_times << gvl_wait_duration_ms

      response
    end

    def log_gvl_wait_time_data
      values_to_send = []

      # Moving data out of the shared array
      values_to_send = @@gvl_wait_times.dup
      @@gvl_wait_times.clear

      values_to_send.each do |gvl_wait_time|
        # TODO -- Persist this information
        puts "[Gvlwait] gvl_wait_time=#{gvl_wait_time}"
      end
    end
  end
end
