# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{echelon}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lloyd Pick"]
  s.date = %q{2010-10-20}
  s.description = %q{RubyGem to give quick access to Theme Park queue times}
  s.email = ["lloydpick@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/echelon.rb", "lib/echelon/ride.rb", "lib/echelon/thorpe_park.rb", "test/test_echelon.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/lloydpick/echelon}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{echelon}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{RubyGem to give quick access to Theme Park queue times}
  s.test_files = ["test/test_helper.rb", "test/test_echelon.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 1.4.6"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<hoe>, [">= 2.6.2"])
    else
      s.add_dependency(%q<json_pure>, [">= 1.4.6"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<hoe>, [">= 2.6.2"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 1.4.6"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<hoe>, [">= 2.6.2"])
  end
end
