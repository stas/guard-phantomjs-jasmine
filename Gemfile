source :rubygems

# Specify your gem's dependencies in guard-phantomjs-jasmine.gemspec
gemspec

require 'rbconfig'

if RbConfig::CONFIG['target_os'] =~ /darwin/i
  gem 'rb-fsevent'
  gem 'growl'
end
if RbConfig::CONFIG['target_os'] =~ /linux/i
  gem 'rb-inotify'
  gem 'libnotify'
end
