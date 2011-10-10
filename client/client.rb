require 'httparty'
require File.join(File.dirname(__FILE__), 'client/shared_files')
require File.join(File.dirname(__FILE__), 'client/command_line')

if ARGV.size < 1
  puts "Usage: ruby #{__FILE__} shared-directory"
  exit -1
end

puts "Starting thread to monitor files and register them on the server..."
file_monitoring_thread = SharedFiles.monitor(ARGV.first)
puts "Starting command line..."
CommandLine.new.run