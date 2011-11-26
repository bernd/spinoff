require 'socket'
require 'spinoff/socket_path'

module Spinoff
  module Server
    class Generic
      def self.start(config)
        new(config).start
      end

      attr_reader :config, :socket

      def initialize(config)
        @config = config
        @socket = create_socket
      end

      def init_script
        File.expand_path(@config.fetch(:init_script, File.join(Dir.pwd, 'spinoff.rb')))
      end

      def start
        raise "#{self.class}#start not implemented."
      end

      def accept_loop
        loop do
          connection = socket.accept
          files = connection.gets.chomp.split(File::PATH_SEPARATOR)

          disconnect_client(connection)
          yield(files)
        end
      end

      def disconnect_client(client)
        client.print("\0")
        client.close
      end

      private
      def create_socket
        path = Spinoff.socket_path
        File.delete(path) if File.exist?(path)
        UNIXServer.open(path)
      end
    end
  end
end
