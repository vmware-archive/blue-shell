require 'blue_shell'
require 'rr'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |file|
  require file
end

RSpec.configure do |config|
  config.mock_with :rr

  config.include BlueShell::Helpers
end

