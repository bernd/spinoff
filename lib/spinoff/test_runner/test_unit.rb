module Spinoff
  module TestRunner
    class TestUnit
      def <<(files)
        Array(files).each {|file| require File.expand_path(file) }
      end
    end
  end
end
