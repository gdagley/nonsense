(in /Users/geoffrey/workspace/nonsense)
Gem::Specification.new do |s|
  s.name = %q{nonsense}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Geoffrey Dagley"]
  s.date = %q{2008-06-25}
  s.description = %q{port of http://nonsense.sourceforge.net/  Taken from Nonsense website:  Nonsense generates random (and sometimes humorous)  text from datafiles and templates using a very simple, recursive grammar. It's  like having a million monkeys sitting in front of a million typewriters, without  having to feed or clean up after them.}
  s.email = ["gdagley@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "LICENSE.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "LICENSE.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/default.yml", "lib/nonsense.rb", "test/test_nonsense.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{nonsense}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{port of http://nonsense.sourceforge.net/  Taken from Nonsense website:  Nonsense generates random (and sometimes humorous)  text from datafiles and templates using a very simple, recursive grammar}
  s.test_files = ["test/test_nonsense.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<hoe>, [">= 1.6.0"])
    else
      s.add_dependency(%q<hoe>, [">= 1.6.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.6.0"])
  end
end
