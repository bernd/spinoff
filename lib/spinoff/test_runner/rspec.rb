require 'rspec/core'

module Spinoff
  module TestRunner
    class RSpec
      def <<(files)
        # Overwrite the trap_interrupt method to avoid weird behaviour
        # on SIGINT.
        ::RSpec::Core::Runner.class_eval do
          def self.trap_interrupt; end
        end

        ::RSpec::Core::Runner.run(files)
      end
    end
  end
end
