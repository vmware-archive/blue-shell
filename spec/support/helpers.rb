module BlueShell
  module Helpers
    def asset(file)
      File.expand_path("../../assets/#{file}", __FILE__)
    end
  end
end
