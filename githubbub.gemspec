# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{githubbub}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tim Pease"]
  s.date = %q{2009-04-01}
  s.default_executable = %q{githubbub}
  s.description = %q{What you're looking for is over on GitHub, bub!  This little gem will build an "auto-forwarder" gem that you can upload to RubyForge. The auto-forwarder, when installed, will automatically install your gem from the GitHub gem repository. Obviously this implies that you need a GitHub account and a project that is configured to automatically build gems.  GitHub-Bub relies on the presence of .gemspec file in the current directory. All the information about your gem is gleaned from this file. The only information you need to provide is your GitHub username.  You still need to have a project and package on RubyForge for the gem publishing to work properly.  Enjoy!}
  s.email = %q{tim.pease@gmail.com}
  s.executables = ["githubbub"]
  s.extra_rdoc_files = ["History.txt", "README.rdoc", "bin/githubbub"]
  s.files = ["History.txt", "README.rdoc", "Rakefile", "bin/githubbub", "lib/githubbub.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://codeforpeople.rubyforge.org/githubbub}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{codeforpeople}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{What you're looking for is over on GitHub, bub!  This little gem will build an "auto-forwarder" gem that you can upload to RubyForge}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubyforge>, [">= 1.0.2"])
      s.add_development_dependency(%q<bones>, [">= 2.4.2"])
    else
      s.add_dependency(%q<rubyforge>, [">= 1.0.2"])
      s.add_dependency(%q<bones>, [">= 2.4.2"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 1.0.2"])
    s.add_dependency(%q<bones>, [">= 2.4.2"])
  end
end
