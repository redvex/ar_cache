# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ar_cache}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gianni Mazza"]
  s.date = %q{2009-08-11}
  s.description = %q{Performe ActiveRecord cache in File System for heavy and repetitive query.}
  s.email = %q{redvex@me.com}
  s.extra_rdoc_files = ["CHANGELOG", "lib/ar_cache.rb", "README.rdoc"]
  s.files = ["ar_cache.gemspec", "CHANGELOG", "init.rb", "lib/ar_cache.rb", "Manifest", "Rakefile", "README.rdoc"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/redvex/ar_cache}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Ar_cache", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ar_cache}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Performe ActiveRecord cache in File System for heavy and repetitive query.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
  end
end
