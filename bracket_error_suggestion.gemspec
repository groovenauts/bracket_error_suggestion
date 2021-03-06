# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bracket_error_suggestion/version'

Gem::Specification.new do |spec|
  spec.name          = "bracket_error_suggestion"
  spec.version       = BracketErrorSuggestion::VERSION
  spec.authors       = ["akima"]
  spec.email         = ["akm2000@gmail.com"]
  spec.description   = %q{suggests Hash or Array access on error with invalid key or index}
  spec.summary       = %q{suggests Hash or Array access on error with invalid key or index}
  spec.homepage      = "https://github.com/groovenauts/bracket_error_suggestion"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
