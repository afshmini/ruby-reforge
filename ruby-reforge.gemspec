# frozen_string_literal: true

require_relative "lib/ruby/reforge/version"

Gem::Specification.new do |spec|
  spec.name          = "ruby-reforge"
  spec.version       = Ruby::Reforge::VERSION
  spec.authors       = ["Afshin Amini"]
  spec.email         = ["afshmini@gmail.com"]

  spec.summary       = "Automatically upgrade Ruby projects to newer versions and fix deprecated code"
  spec.description   = <<~DESC
    ruby-reforge is a gem that scans a Ruby or Rails project, detects incompatible code
    for a target Ruby version, and automatically rewrites or suggests fixes. It updates
    version files, fixes deprecated syntax, rewrites code for new Ruby syntax, and
    suggests Rails-level incompatibilities.
  DESC
  spec.homepage      = "https://github.com/afshmini/ruby-reforge"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.0"
  spec.add_dependency "prism", "~> 0.24"
  spec.add_dependency "parser", "~> 3.3"
  spec.add_dependency "unparser", "~> 0.6"
  spec.add_dependency "rainbow", "~> 3.1"
  spec.add_dependency "tty-prompt", "~> 0.23"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rubocop", "~> 1.50"
end

