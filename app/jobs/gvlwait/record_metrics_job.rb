module Gvlwait
  class RecordMetricsJob < ApplicationJob
    queue_as :default

    def perform(metrics)
      metrics.each do |metric|
        Gvlwait::Metric.create!(metric)
      end
    end
  end
end
