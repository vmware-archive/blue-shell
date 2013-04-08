$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'blue-shell/version'

Gem::Specification.new do |s|
  s.name        = 'blue-shell'
  s.version     = BlueShell::VERSION.dup
  s.authors     = ['Pivotal Labs']
  s.email       = %w(cfpi-frontend@googlegroups.com)
  s.homepage    = 'http://github.com/cloudfoundry/cf'
  s.summary     = %q{
    Friendly command-line test runner and matchers for shell scripting in ruby using rspec.
  }

  s.files         = %w(LICENSE Rakefile) + Dir['lib/**/*']
  s.test_files    = Dir['spec/**/*']
  s.require_paths = %w(lib)
  s.license       = 'MIT'

  s.add_dependency 'rspec'

  s.add_development_dependency 'rake'

  s.add_development_dependency 'rr'
end

