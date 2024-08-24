module VioletArchives
  # Outputs to both the console and a file
  class Printer
    def initialize(file)
      @file = File.open(file, 'w')
    end

    def print(str)
      write(str)
      $stdout.print str
    end

    def puts(str)
      write("#{str}\n")
      $stdout.puts str
    end

    def write(str)
      @file << str
    end

    def close
      @file.close
    end
  end
end
