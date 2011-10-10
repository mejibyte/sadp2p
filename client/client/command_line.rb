class CommandLine
  def initialize
    @current_dir = ""
  end

  def run
    while true
      print "SADP2P > "
      s = STDIN.gets.chomp

      case s
      when "ls"
        print_files SharedFiles.ls(@current_dir)
      when "exit"
        puts "Bye."
        exit 0
      else
        puts "Unknown command"
      end
    end
  end
  
  def print_files(files)
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