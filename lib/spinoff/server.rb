module Spinoff
  module Server
    def self.start(config)
      case RUBY_PLATFORM
      when /java/i
        require 'spinoff/server/jruby'
        Spinoff::Server::JRuby.start(config)
      else
        require 'spinoff/server/fork'
        Spinoff::Server::Fork.start(config)
      end
    end
  end
end
