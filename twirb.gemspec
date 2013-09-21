# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'twirb/version'

Gem::Specification.new do |spec|
  spec.name          = "twirb"
  spec.version       = Twirb::VERSION
  spec.authors       = ["Antonio"]
  spec.email         = ["antalby@hotmail.com"]
  spec.description   = %q{Twirb is a Ruby text-editor and an alternative to irb, with syntax highlighting and indentation for writing ruby code and executing it directly in your terminal}
  spec.summary       = %q{twirb is a ruby text editor}
  spec.homepage      = "http://www.twirb.org"
  spec.license       = "MIT"
  spec.executables = ['twirb']
  spec.require_paths = ["lib"]
  spec.files = Dir.glob('lib/**/*.rb')

  
  
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})


  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
