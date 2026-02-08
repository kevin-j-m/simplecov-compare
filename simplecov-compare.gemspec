# frozen_string_literal: true

require_relative "lib/simplecov/compare/version"

Gem::Specification.new do |spec|
  spec.name = "simplecov-compare"
  spec.version = Simplecov::Compare::VERSION
  spec.authors = ["Kevin Murphy"]
  spec.email = ["kevin@kevinjmurphy.com"]

  spec.summary = "A way to compare two SimpleCov runs."
  spec.description = "Given two resultset.json files, this will tell you what changed."
  spec.homepage = "https://github.com/kevin-j-m/simplecov-compare"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kevin-j-m/simplecov-compare"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .rubocop.yml])
    end
  end
  spec.bindir = "bin"
  spec.executables << "simplecov-compare"
  spec.require_paths = ["lib"]

  spec.add_dependency "glamour"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
