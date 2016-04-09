# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

#require "ricer4/math/version.rb"

Gem::Specification.new do |spec|
  spec.name          = "ricer4-math"
  spec.version       = "4.0.0" # Ricer4::Plugins::Math::VERSION
  spec.authors       = ["gizmore"]
  spec.email         = ["gizmore@wechall.net"]

  spec.summary       = "Math plugins for the Ricer4 Chatbot."
  spec.homepage      = "https://github.com/gizmore/ricer4-math"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
#  spec.bindir        = "exe"
#  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "byebug", "~> 8.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"

  spec.add_runtime_dependency "ricer4", "~> 0.1"

end
