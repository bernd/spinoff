require 'spinoff/server/generic'
require 'spinoff/test_runner'
require 'benchmark'

module Spinoff
  module Server
    class Fork < Spinoff::Server::Generic
      def start
        test_runner = Spinoff::TestRunner.init(config[:test_framework])
        load_init_script(init_script)

        accept_loop do |files|
          start = Time.now

          fork do
            STDERR.puts "Loading #{files.inspect}"
            test_runner << files
          end

          Process.wait

          STDERR.puts "Execution time: %.4fs" % (Time.now - start)
        end
      end

      private
      def load_init_script(file)
        if File.exist?(file)
          sec = Benchmark.realtime do
            require File.expand_path(file)
          end
          STDERR.puts "Loaded init script in %.4fs (%s)" % [sec, file]
        else
          STDERR.puts "WARNING: Init script '#{file}' does not exist!"
        end
      end
    end
  end
end
