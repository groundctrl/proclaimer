# encoding: UTF-8
require "./lib/proclaimer/version"

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "proclaimer"
  s.version = Proclaimer::VERSION
  s.summary = "An easy, and extensible transactional event notification " +
    "add on for Spree."
  s.description = s.summary
  s.required_ruby_version = ">= 2.2.0"

  s.authors = ["Vincent Franco", "David Freerksen"]
  s.homepage  = "https://github.com/groundctrl/proclaimer"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = "lib"
  s.requirements << "none"

  s.add_dependency "spree_backend", "~> 2.4.6"

  s.add_development_dependency "capybara", "~> 2.4"
  s.add_development_dependency "coffee-rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl", "~> 4.5"
  s.add_development_dependency "rspec-rails",  "~> 3.1"
  s.add_development_dependency "sass-rails", "~> 4.0.2"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "sqlite3"
end
