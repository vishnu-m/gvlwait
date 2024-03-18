namespace :gvlwait do
  desc "Print average GVL wait times grouped by concurrency level in a table format"
  task print_average_wait_times: :environment do
    averages = Gvlwait::Duration.average_wait_times_by_concurrency

    header = "Concurrency Level | Average GVL Wait Time (ms)"

    puts header
    puts "-" * header.length

    averages.each do |concurrency_level, average_time|
      puts "#{concurrency_level} | #{average_time.round(2)}"
    end
  end
end
