require 'xdg'

module Notes
  class Configuration
    include XDG::BaseDir::Mixin

    def subdirectory
      'Notes'
    end
  end
end
