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
        puts "ls"
      when "exit"
        puts "Bye."
        exit 0
      else
        puts "Unknown command"
      end
    end
  end
end