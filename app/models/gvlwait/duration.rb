module Gvlwait
  class Duration < ApplicationRecord
    validates :process_type, presence: true, inclusion: { in: ['web', 'worker'] }
    validates :concurrency_level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
    def self.average_wait_times_by_concurrency
      group(:concurrency_level).average(:wait_duration)
    end
  end
end
