require 'socket'
require 'spinoff/socket_path'

module Spinoff
  module Client
    def self.start(argv)
      files = argv.select {|f| File.exist?(f) }.uniq.join(File::PATH_SEPARATOR)

      return if files.empty?

      socket = UNIXSocket.open(Spinoff.socket_path)
      socket.puts files

      while line = socket.gets
        break if line == "\0"
        print line
      end
    rescue Errno::ECONNREFUSED
      abort "Connection to spinoff server was refused."
    end
  end
end
