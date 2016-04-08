# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "factory_girl_remote_strategy/version"

Gem::Specification.new do |spec|
  spec.name          = "factory_girl_remote_strategy"
  spec.version       = FactoryGirlRemoteStrategy::VERSION
  spec.authors       = ["Alex Avoyants"]
  spec.email         = ["shhavel@gmail.com"]
  spec.summary       = %q{FactoryGirl strategy for ActiveResource models.}
  spec.description   = %q{FactoryGirl strategy for ActiveResource models.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", '>= 3.2'
  spec.add_dependency "activeresource", '>= 3.2'
  spec.add_dependency "factory_girl"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "fakeweb"
end
