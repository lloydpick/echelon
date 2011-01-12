# -*- encoding: utf-8 -*-

require File.expand_path("../lib/echelon/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "echelon"
  s.version     = Echelon::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lloyd Pick"]
  s.email       = ["lloydpick@gmail.com"]
  s.homepage    = "http://github.com/lloydpick/echelon"
  s.summary     = "RubyGem to give quick access to Theme Park queue times"
  s.description = "RubyGem to give quick access to Theme Park queue times (Disneyland Paris, Thorpe Park, Seaworld San Antonio supported)"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "echelon"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", ">= 2.4.0"

  s.add_dependency "json_pure", "1.4.6"
  s.add_dependency "zip", "2.0.2"
  s.add_dependency "xml-simple", "1.0.12"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end