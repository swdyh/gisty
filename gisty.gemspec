# -*- encoding: utf-8 -*-
# stub: gisty 0.2.9 ruby lib

Gem::Specification.new do |s|
  s.name = "gisty".freeze
  s.version = "0.2.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["swdyh".freeze]
  s.date = "2020-02-16"
  s.description = "yet another command line client for gist. Gisty uses Github API V3 via OAuth2.".freeze
  s.email = "http://mailhide.recaptcha.net/d?k=01AhB7crgrlHptVaYRD0oPwA==&c=L_iqOZrGmo6hcGpPTFg1QYnjr-WpAStyQ4Y8ShfgOHs=".freeze
  s.executables = ["gisty".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = ["README.rdoc".freeze, "Rakefile".freeze, "bin/gisty".freeze, "lib/commands".freeze, "lib/commands/about.rb".freeze, "lib/commands/gyast.rb".freeze, "lib/commands/help.rb".freeze, "lib/commands/list.rb".freeze, "lib/commands/post.rb".freeze, "lib/commands/private_post.rb".freeze, "lib/commands/pull_all.rb".freeze, "lib/commands/sync.rb".freeze, "lib/commands/sync_delete.rb".freeze, "lib/gisty.rb".freeze, "test/fixtures".freeze, "test/fixtures/bar.user.js".freeze, "test/fixtures/foo.user.js".freeze, "test/fixtures/gists_1".freeze, "test/fixtures/gists_2".freeze, "test/fixtures/gists_3".freeze, "test/fixtures/gists_post".freeze, "test/gisty_test.rb".freeze, "test/test_helper.rb".freeze]
  s.homepage = "http://github.com/swdyh/gisty/tree/master".freeze
  s.rdoc_options = ["--title".freeze, "gisty documentation".freeze, "--charset".freeze, "utf-8".freeze, "--line-numbers".freeze, "--main".freeze, "README.rdoc".freeze, "--inline-source".freeze, "--exclude".freeze, "^(examples|extras)/".freeze]
  s.rubygems_version = "2.7.6.2".freeze
  s.summary = "yet another command line client for gist.".freeze
  s.test_files = ["test/gisty_test.rb".freeze]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<json>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rr>.freeze, ["<= 1.1.2"])
      s.add_development_dependency(%q<fakeweb>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 4.0"])
      s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<json>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rr>.freeze, ["<= 1.1.2"])
      s.add_dependency(%q<fakeweb>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 4.0"])
      s.add_dependency(%q<test-unit>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rr>.freeze, ["<= 1.1.2"])
    s.add_dependency(%q<fakeweb>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 4.0"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3.0"])
  end
end
