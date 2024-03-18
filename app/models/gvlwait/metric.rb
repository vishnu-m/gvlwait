module Gvlwait
  class Metric < ApplicationRecord
    validates :process_type, presence: true, inclusion: { in: ['web', 'worker'] }
    validates :concurrency_level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
    def self.average_gvl_wait_times_by_concurrency
      group(:concurrency_level).average(:gvl_wait_time)
    end

    def self.average_processing_times_by_concurrency
      group(:concurrency_level).average(:processing_time)
    end
  end
end
