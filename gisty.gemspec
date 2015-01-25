# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "gisty"
  s.version = "0.2.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["swdyh"]
  s.date = "2015-01-25"
  s.description = "yet another command line client for gist. Gisty uses Github API V3 via OAuth2."
  s.email = "http://mailhide.recaptcha.net/d?k=01AhB7crgrlHptVaYRD0oPwA==&c=L_iqOZrGmo6hcGpPTFg1QYnjr-WpAStyQ4Y8ShfgOHs="
  s.executables = ["gisty"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "bin/gisty", "test/fixtures", "test/fixtures/bar.user.js", "test/fixtures/foo.user.js", "test/fixtures/gists_1", "test/fixtures/gists_2", "test/fixtures/gists_3", "test/fixtures/gists_post", "test/gisty_test.rb", "test/test_helper.rb", "lib/commands", "lib/commands/about.rb", "lib/commands/gyast.rb", "lib/commands/help.rb", "lib/commands/list.rb", "lib/commands/post.rb", "lib/commands/private_post.rb", "lib/commands/pull_all.rb", "lib/commands/sync.rb", "lib/commands/sync_delete.rb", "lib/gisty.rb"]
  s.homepage = "http://github.com/swdyh/gisty/tree/master"
  s.rdoc_options = ["--title", "gisty documentation", "--charset", "utf-8", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "gisty"
  s.rubygems_version = "2.0.3"
  s.summary = "yet another command line client for gist."
  s.test_files = ["test/gisty_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
      s.add_development_dependency(%q<minitest>, ["~> 4.0"])
      s.add_development_dependency(%q<test-unit>, ["~> 3.0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<minitest>, ["~> 4.0"])
      s.add_dependency(%q<test-unit>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<minitest>, ["~> 4.0"])
    s.add_dependency(%q<test-unit>, ["~> 3.0"])
  end
end
