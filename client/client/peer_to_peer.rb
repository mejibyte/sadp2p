class PeerToPeer
  DEFAULT_PORT = 16807
  
  def initialize(base_dir, port = DEFAULT_PORT)
    @base_dir = base_dir
    @port = port
  end
  
  def listen_for_incoming_connections
    puts "Listening for incoming connections on port #{@port}."
    Thread.new do 
      Socket.tcp_server_loop(@port) do |sock, client_addrinfo|
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

  def ask_for_file(host, file, save_as)
    host, port = host.split(":")
    port ||= DEFAULT_PORT
    begin
      socket = TCPSocket.new(host, port)
      socket.puts file
      # Receive file here and write it to file
      receive_file(socket, file, save_as)
    rescue => e
      puts "Connection failed with message: '#{e.message}'. Maybe the peer just left?"
    end
  end
  
  
  private

  def receive_file(sock, filename, save_as)
    IO.copy_stream(sock, File.new(save_as, 'w'))
    if File.size?(save_as)
      puts "Transfer complete. Saved file to #{save_as}."
      return true
    else
      puts "The peer didn't send any data. Transfer failed!\n"
      File.delete(save_as)
      return false
    end
  end
  
  def send_file(sock, filename)
    full_path = File.join(@base_dir, filename)
    if File.exists?(full_path)
      puts "#{full_path} exists. Starting transfer!"
      IO.copy_stream(File.new(full_path), sock)
    else
      puts "'#{filename}' does not exist."
    end
  end
end
