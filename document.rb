require 'Qt4'

class Document < Qt::TextDocument
  attr_accessor :title, :text, :links

  def initialize(title = "newDocument", text = nil)
    super()
    @title      = title
    @text       = text
    @links      = []

    puts "Document.new(#{title}, #{text})"
  end

  def linkTo(string, doc)
    puts "Linking #{self.title} to #{doc.title}"
    l = Link.new(string, doc)
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
  end

  def load
    # TODO
  end
end
