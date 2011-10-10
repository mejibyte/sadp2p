require 'httparty'
require File.join(File.dirname(__FILE__), 'client/shared_files')
require File.join(File.dirname(__FILE__), 'client/command_line')
require File.join(File.dirname(__FILE__), 'client/peer_to_peer')


if ARGV.size < 1
  puts "Usage: ruby #{__FILE__} shared-directory"
  exit -1
end

puts "Starting thread to monitor files and register them on the server..."
file_monitoring_thread = SharedFiles.monitor(ARGV.first)

peer_to_peer = PeerToPeer.new(ARGV.first)
accept_connections_thread = peer_to_peer.listen_for_incoming_connections

puts "Starting command line..."
CommandLine.new(ARGV.first).run
