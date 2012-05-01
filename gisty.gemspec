# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gisty}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["swdyh"]
  s.date = %q{2012-05-01}
  s.default_executable = %q{gisty}
  s.description = %q{yet another command line client for gist. Gisty uses Github API V3 via OAuth2.}
  s.email = %q{http://mailhide.recaptcha.net/d?k=01AhB7crgrlHptVaYRD0oPwA==&c=L_iqOZrGmo6hcGpPTFg1QYnjr-WpAStyQ4Y8ShfgOHs=}
  s.executables = ["gisty"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "bin/gisty", "test/fixtures", "test/fixtures/bar.user.js", "test/fixtures/foo.user.js", "test/fixtures/gists_1", "test/fixtures/gists_2", "test/fixtures/gists_3", "test/fixtures/gists_post", "test/gisty_test.rb", "test/test_helper.rb", "lib/commands", "lib/commands/about.rb", "lib/commands/gyast.rb", "lib/commands/help.rb", "lib/commands/list.rb", "lib/commands/post.rb", "lib/commands/private_post.rb", "lib/commands/pull_all.rb", "lib/commands/sync.rb", "lib/commands/sync_delete.rb", "lib/gisty.rb"]
  s.homepage = %q{http://github.com/swdyh/gisty/tree/master}
  s.rdoc_options = ["--title", "gisty documentation", "--charset", "utf-8", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gisty}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{yet another command line client for gist.}
  s.test_files = ["test/gisty_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
