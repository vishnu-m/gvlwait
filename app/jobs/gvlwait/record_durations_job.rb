module Gvlwait
  class RecordDurationsJob < ApplicationJob
    queue_as :default

    def perform(gvl_wait_durations, process_type, concurrency_level)
      gvl_wait_durations.each do |gvl_wait_duration|
        Gvlwait::Duration.create!(
          wait_duration: gvl_wait_duration,
          process_type: process_type,
          concurrency_level: concurrency_level
        )
      end
    end
  end
end
