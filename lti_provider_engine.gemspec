$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "lti_provider/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "lti_provider_engine"
  s.version     = LtiProvider::VERSION
  s.authors     = ["Dave Donahue", "Adam Anderson", "Simon Williams"]
  s.email       = ["adam.anderson@12spokes.com", "simon@instructure.com"]
  s.homepage    = "https://github.com/instructure/lti_provider_engine"
  s.license     = 'MIT'
  s.summary     = <<-SUM
LtiProvider is a mountable engine for handling the LTI launch and exposing LTI
parameters in your rails app.
SUM

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.required_ruby_version = '>= 2.6.0'

  s.add_dependency "rails", ">= 5.0", "< 7.0"
  s.add_dependency 'ims-lti', '~> 1.2'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'nokogiri'
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-rails-mocha"
  s.add_development_dependency "webmock"
  s.add_development_dependency "byebug"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "sprockets", "~>3.0"
end
