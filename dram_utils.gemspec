# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dram_utils/version'

Gem::Specification.new do |spec|
  spec.name = "dram_utils"
  spec.version = DramUtils::VERSION
  spec.authors = ["dramforever"]
  spec.email = ["dramforever@live.com"]
  spec.summary = %q{dramforever utilities}
  spec.description = %q{Some small utilities}
  spec.homepage = ""
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "thin"

  spec.add_dependency "sinatra"
  spec.add_dependency "json"
  spec.add_dependency "net-ping"
  spec.add_dependency "whois"
  spec.add_dependency "haml"
end
