require 'Qt4'
require File.join('.', 'configuration.rb')
require File.join('.', 'project.rb')
require File.join('.', 'document.rb')
require File.join('.', 'window.rb')

module Notes
  class Application < Qt::Application
    def initialize(projectTitle = 'newProject', documentTitle = 'newDocument')
      super(ARGV)
      @config     = Notes::Configuration.new()
      @project    = Notes::Project.new(projectTitle, @config.config.home.to_s)
      @document   = Notes::Document.new(@project, documentTitle)

      w = Notes::Window.new(@project, @document)
      w.show()
      self.exec()
    end
  end
end
