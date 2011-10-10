class PeerToPeer
  PORT = 16807
  
  def initialize(base_dir)
    @base_dir = base_dir
    puts @base_dir
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
    receive_file(socket, file)
  end
  
  
  private

  def receive_file(sock, filename)
    while true
      puts "Please enter full path where you want to save file."
      path = STDIN.gets.chomp
      if File.directory?(path)
        puts "#{path} is a directory. Enter a full path instead."
      elsif File.exists?(path)
        print "#{path} already exists. Overwrite? [y/n] "
        answer = STDIN.gets.chomp
        break if answer == "y"
      elsif !File.exists?(File.dirname(path))
        puts "#{File.dirname(path)} does not exist."
      else
        break
      end
    end

    IO.copy_stream(sock, File.new(path, 'w'))
    if File.size?(path)
      puts "Transfer complete. Saved file as #{path}."
      return true
    else
      puts "The peer didn't send any data. Transfer failed!\n"
      File.delete(path)
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
