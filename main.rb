require 'Qt4'
require File.join('.', 'project.rb')
require File.join('.', 'document.rb')
require File.join('.', 'window.rb')

class Notes < Qt::Application
  def initialize(projectTitle = 'newProject', documentTitle = 'newDocument')
    super(ARGV)
    @project    = Project.new(projectTitle)
    @document   = Document.new(@project, documentTitle)

    w = Window.new(@project, @document)
    w.show()
    self.exec()
  end
end

notes = Notes.new()
