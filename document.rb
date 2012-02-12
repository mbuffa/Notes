require 'Qt4'

class Document < Qt::TextDocument
  attr_accessor :title, :text, :links
  slots 'update(text)'
  slots 'linkTo(string, document)'

  def initialize(project, title = 'newDocument')
    super()

    @project    = project
    @title      = title
    @text       = ""
    @links      = []

    puts "Document.new(#{project.title}, #{title})"

    @project.add(self)
  end

  def destroy
    @project.rm(self)
  end

  def update(text)
    @text = text
  end

  def linkTo(string, document)
    puts "Linking #{self.title} to #{document.title}"
    l = Link.new(string, document)
    @links.push(l)
  end

  def unlink(string, doc)
    puts "Unlinking #{string} to #{doc}"
    # STUB
  end

  def save?
    # TODO
    # Here, scan last modification time of file.
    # If lesser than 20 seconds (changeable), returns false.
    puts "Document.save?(): TODO"

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
