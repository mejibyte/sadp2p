class PeerToPeer
  PORT = 16807
  
  def initialize(base_dir)
    @base_dir = base_dir
  end
  
  def listen_for_incoming_connections
    puts "Listening for incoming connections on port #{PORT}."
    Thread.new do 
      Socket.tcp_server_loop(PORT) do |sock, client_addrinfo|
        Thread.new do
          begin
            puts "Got a connection from #{client_addrinfo.ip_address}. Let's see what they want..."
            filename = sock.gets.chomp
            puts "  They want file '#{filename}'"
            send_file sock, filename
          ensure
            sock.close
          end
        end
      end
    end
  end

  def ask_for_file(host, file)
    socket = TCPSocket.new(host, PORT)
    socket.puts file
    # Receive file here and write it to file
  end
  
  
  private
  
  def send_file(sock, filename)
    full_path = File.join(@base_dir, filename)
    if File.exists?(full_path)
      IO.copy_stream(File.new(full_path), sock)
    else
      puts "'#{filename}' does not exist."
    end
  end
end
