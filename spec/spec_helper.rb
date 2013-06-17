require 'blue-shell'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |file|
  require file
end

RSpec.configure do |config|
  config.include BlueShell::Helpers
  config.include EscapedKeys
end

