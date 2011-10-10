# encoding: utf-8

class CommandLine
  def initialize(base_dir)
    @base_dir = base_dir
    @current_dir = ""
  end

  def run
    while true
      print "SADP2P '/#{@current_dir}'> "
      s = STDIN.gets.chomp

      case s.split.first
      when "ls"
        ls
      when "cd"
        cd s.split[1]
      when "cp"
        cp s.split[1]
      when "exit"
        puts "Bye."
        exit 0
      else
        puts "Unknown command"
      end
    end
  end
  
  private
  
  def cp(some_file)
    save_as = File.join(@base_dir, @current_dir, some_file)
    if File.exists?(save_as)
      puts "You already have that file. Aborting."
      return
    end
    puts "Asking server for information about '#{some_file}'..."
    file = File.join(@current_dir, some_file)
    file = file[1..-1] if file[0] == "/"
    peers = SharedFiles.show(file)
    if peers.empty?
      puts "'#{some_file}' doesn't exist or isn't available anymore."
      return
    end
    peers.each do |p|
      puts "  Asking #{p} for the file..."
    end
  end
  
  def cd(some_directory)
    if some_directory.nil?
      puts "Usage: cd some-directory"
      return
    end
    
    if some_directory == "."
      return
    end
    
    if some_directory == ".."
      path = File.split(@current_dir)
      path.pop
      path = [""] if path.empty? or path == ["."]
      
      @current_dir = File.join(path)
      @current_dir = @current_dir[1..-1] if @current_dir[0] == "/"
      return
    end
    
    @current_dir = File.join(@current_dir, some_directory)
    @current_dir = @current_dir[1..-1] if @current_dir[0] == "/"
  end
  
  def ls
    files = SharedFiles.ls(@current_dir)
    if files.empty?
      return 
    end
    files.each do |f|
      if f.start_with?(@current_dir + "/")
        f.sub!(@current_dir + "/", "")
      end
    end
    files.sort!
    longest_length = files.map(&:size).max + 3
    files_per_line = 80 / longest_length
    files.each_slice(files_per_line) do |some_files|
      some_files.each do |f|
        print ("%-#{longest_length}s" % f)
      end
      puts ""
    end
  end
end