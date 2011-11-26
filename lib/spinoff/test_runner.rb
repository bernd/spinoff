module Spinoff
  module TestRunner
    def self.init(framework)
      STDERR.puts "Test framework: #{framework}"

      case framework
      when :rspec
        require 'spinoff/test_runner/rspec'
        Spinoff::TestRunner::RSpec.new
      when :testunit
        require 'spinoff/test_runner/test_unit'
        Spinoff::TestRunner::TestUnit.new
      end
    end
  end
end
