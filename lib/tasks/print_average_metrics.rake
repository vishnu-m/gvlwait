namespace :gvlwait do
  desc "Print metrics grouped by concurrency level"
  task print_average_metrics: :environment do
    wait_time_averages = Gvlwait::Metric.average_gvl_wait_times_by_concurrency
    processing_time_averages = Gvlwait::Metric.average_processing_times_by_concurrency
    request_queue_time_averages = Gvlwait::Metric.average_request_queue_times_by_concurrency

    header = "Concurrency Level | GVL Wait Time (ms) | Queue Time (ms) | Rack Response Time (ms)"
    puts header
    puts "-" * header.length

    concurrency_levels = wait_time_averages.keys | processing_time_averages.keys | request_queue_time_averages.keys
    concurrency_levels.sort.each do |concurrency_level|
      wait_time = wait_time_averages[concurrency_level]&.round(2) || 'N/A'
      queue_time = request_queue_time_averages[concurrency_level]&.round(2) || 'N/A'
      rack_time = processing_time_averages[concurrency_level]&.round(2) || 'N/A'

      puts "#{concurrency_level} | #{wait_time} | #{queue_time} | #{rack_time}"
    end
  end
end
