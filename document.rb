require 'Qt4'

class Document < Qt::TextDocument
  attr_accessor :text, :title

  def initialize(project, title = 'newDocument')
    super()

    @project    = project
    @title      = title

    puts "Document.new(#{project.title}, #{title})"

    @project.add(self)
  end

  def destroy
    @project.rm(self)
  end

  def save?
    # TODO
    # Here, scan last modification time of file.
    # If lesser than 20 seconds (changeable), returns false.
#    puts "Document.save?(): TODO"

    return true
  end

  def save!
    # This function effectively saves file on disc drive.
#    File.new(File.join('.', @currentProject.title, @title, "a+")
  end

  def load
    # TODO
  end
end
