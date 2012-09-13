# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'guard-phantomjs-jasmine'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Stas Suscov']
  s.email       = ['stas@nerd.ro']
  s.homepage    = 'http://github.com/stas/guard-phantomjs-jasmine'
  s.summary     = 'Guard for running Jasmine specs using PhantomJS'
  s.description = 'PhantomJS guard allows to automatically run PhantomJS (headless, WebKit-based browser) Jasmine specs.'

  s.rubyforge_project = 'guard-phantomjs-jasmine'

  s.add_dependency 'guard'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard-rspec'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
