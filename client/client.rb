require 'httparty'
require File.join(File.dirname(__FILE__), 'client/shared_files')
require File.join(File.dirname(__FILE__), 'client/command_line')
require File.join(File.dirname(__FILE__), 'client/peer_to_peer')


if ARGV.size < 2
  puts "Usage: ruby #{__FILE__} port shared-directory"
  exit -1
end

port             = ARGV[0]
shared_directory = ARGV[1]

puts "Starting thread to monitor files and register them on the server..."
file_monitoring_thread = SharedFiles.monitor(shared_directory, port)

peer_to_peer = PeerToPeer.new(shared_directory, port)
accept_connections_thread = peer_to_peer.listen_for_incoming_connections

puts "Starting command line..."
CommandLine.new(shared_directory).run
