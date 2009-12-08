# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gisty}
  s.version = "0.0.15"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["swdyh"]
  s.date = %q{2009-12-08}
  s.default_executable = %q{gisty}
  s.description = %q{yet another command line client for gist}
  s.email = %q{http://mailhide.recaptcha.net/d?k=01AhB7crgrlHptVaYRD0oPwA==&c=L_iqOZrGmo6hcGpPTFg1QYnjr-WpAStyQ4Y8ShfgOHs=}
  s.executables = ["gisty"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "bin/gisty", "test/fixtures", "test/fixtures/24835", "test/fixtures/30119", "test/fixtures/bar.user.js", "test/fixtures/foo.user.js", "test/fixtures/mine_login_foo_token_bar", "test/fixtures/mine_page_1_login_foo_token_bar", "test/fixtures/mine_page_2_login_foo_token_bar", "test/fixtures/mine_page_3_login_foo_token_bar", "test/fixtures/swdyh", "test/fixtures/swdyh_page_4", "test/gisty_test.rb", "test/test_helper.rb", "lib/gisty.rb"]
  s.homepage = %q{http://github.com/swdyh/gisty/tree/master}
  s.rdoc_options = ["--title", "gisty documentation", "--charset", "utf-8", "--line-numbers", "--main", "README.rdoc", "--inline-source", "--exclude", "^(examples|extras)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gisty}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{yet another command line client for gist}
  s.test_files = ["test/gisty_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.0.0"])
    else
      s.add_dependency(%q<nokogiri>, [">= 1.0.0"])
    end
  else
    s.add_dependency(%q<nokogiri>, [">= 1.0.0"])
  end
end
