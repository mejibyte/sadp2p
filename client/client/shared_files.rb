class SharedFiles
  include HTTParty
  base_uri 'localhost:3000'
  
  def self.register(some_files) # Expects an array like ["/tmp/a.txt", "/c.doc"]
    post('/shared_files', :body => serialize_file_array(some_files))
  end
  
  def self.monitor(some_directory)
    raise "#{some_directory} is not a valid directory" unless File.directory?(some_directory)
    Thread.new do
      while true
        # puts "Sending shared files list to server..."
        files = Dir["#{some_directory}/**/*"].reject { |f| File.directory?(f) }.collect { |f| f.gsub(some_directory + "/", "") }
        # puts "   Files to be sent: #{files.join(", ")}"
        register(files)
        # puts "  Sent!"
        sleep 10
      end
    end
  end

  private
  
  def self.serialize_file_array(some_files)
    some_files.collect { |f| "files[][filename]=#{f}" }.join("&")
  end
end
