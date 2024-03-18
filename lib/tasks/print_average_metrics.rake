namespace :gvlwait do
  desc "Print metrics grouped by concurrency level"
  task print_average_metrics: :environment do
    wait_time_averages = Gvlwait::Metric.average_gvl_wait_times_by_concurrency
    processing_time_averages = Gvlwait::Metric.average_processing_times_by_concurrency

    header = "Concurrency Level | Average GVL Wait Time (ms)"

    puts header
    puts "-" * header.length

    wait_time_averages.each do |concurrency_level, average_time|
      puts "#{concurrency_level} | #{average_time.round(2)}"
    end

    header = "Concurrency Level | Average Rack Response Time (ms)"

    puts header
    puts "-" * header.length

    processing_time_averages.each do |concurrency_level, average_time|
      puts "#{concurrency_level} | #{average_time.round(2)}"
    end
  end
end
