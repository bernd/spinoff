require 'java'
require 'spinoff/server/generic'
require 'benchmark'

module Spinoff
  module Server
    class JRuby < Spinoff::Server::Generic
      import 'org.jruby.embed.PathType'
      import 'org.jruby.embed.LocalContextScope'
      import 'org.jruby.embed.ScriptingContainer'

      def start
        accept_loop do |files|
          start = Time.now

          STDERR.puts "Creating JRuby scripting container"
          context = ScriptingContainer.new(LocalContextScope::SINGLETHREAD)

          if File.exist?(init_script)
            sec = Benchmark.realtime do
              context.run_scriptlet(PathType::ABSOLUTE, init_script)
            end
            STDERR.puts "Loaded init script in %.4fs (%s)" % [sec, init_script]
          else
            STDERR.puts "WARNING: Init script '#{init_script}' does not exist!"
          end

          STDERR.puts "Loading #{files.inspect}"
          context.put('framework', config[:test_framework])
          context.put('files', files)

          context.run_scriptlet <<-__RUBY
            require 'spinoff/test_runner'
            runner = Spinoff::TestRunner.init(framework)
            runner << files
          __RUBY
          context.terminate

          STDERR.puts "Execution time: %.4fs" % (Time.now - start)
        end
      end
    end
  end
end
