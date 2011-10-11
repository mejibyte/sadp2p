require 'uri'

class SharedFiles
  include HTTParty
  base_uri 'sadp2p.heroku.com:80'
  
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
  
  def self.ls(current_dir)
    files = get('/shared_files/list', :query => { :current_dir => current_dir } )
  end
  
  def self.show(some_file)
      get("/shared_files/show", :query => { :filename => some_file } )
  end

  private
  
  def self.serialize_file_array(some_files)
    some_files.collect { |f| "files[][filename]=#{f}" }.join("&")
  end
end
