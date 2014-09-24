# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timecost/version'

Gem::Specification.new do |spec|
  spec.name          = "timecost"
  spec.version       = Timecost::VERSION
  spec.authors       = ["Glenn Y. Rolland"]
  spec.email         = ["glenux@glenux.net"]
  spec.summary       = %q{Use GIT logs to give an estimation of spent time & costs of your projects.}
  spec.description   = %q{Use GIT logs to give an estimation of spent time & costs of your projects.}
  spec.homepage      = "https//github.com/glenux/git-timecost"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 4.7.5"
end
