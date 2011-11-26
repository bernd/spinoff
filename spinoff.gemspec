# -*- encoding: utf-8 -*-
require File.expand_path('../lib/spinoff/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Bernd Ahlers"]
  gem.email         = ["bernd@tuneafish.de"]
  gem.description   = %q{Environment preloader}
  gem.summary       = %q{Spinoff preloads your Ruby environment based on an initialization file.}
  gem.homepage      = "https://github.com/bernd/spinoff"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "spinoff"
  gem.require_paths = ["lib"]
  gem.version       = Spinoff::VERSION
end
