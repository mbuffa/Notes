require 'Qt4'

class Window < Qt::Dialog
  attr_reader :document
  slots :updateTitle, :validateTitle, :updateText, :linkDocument#, :insertReference
#  slots 'linkClicked(QUrl)'
#  signals :referenceFound

  def initialize(project, document)
    super()

    @project     = project
    @document    = document

    #
    # Tool Bar instanciation
    #
    @toolBar            = Qt::ToolBar.new()

    @actionProject      = Qt::Action.new(self)
    @actionProject.text = @project.title

    @actionLink         = Qt::Action.new(self)
    @actionLink.text = 'Link'

    @toolBar.addAction(@actionProject)
    @toolBar.addAction(@actionLink)

    #
    # Text Fields instanciation
    #
    @docTitle   = Qt::LineEdit.new()
    @docTitle.text = @document.title
    @docText    = Qt::TextBrowser.new()
    @docText.readOnly = false
    @docText.openLinks = true
    @docText.openExternalLinks = true
    @docText.html = @document.toHtml()
#    @docText.html = "<a href='http://www.free.fr/'>Link</a>"

    #
    # Layout setup
    #
    @layout     = Qt::VBoxLayout.new()
    @layout.addWidget(@toolBar)
    @layout.addWidget(@docTitle)
    @layout.addWidget(@docText)
    self.setLayout(@layout)

    #
    # Signal connections
    #
    Qt::Object.connect(@docTitle,       SIGNAL('textChanged(QString)'), self, SLOT('updateTitle()'))
    Qt::Object.connect(@docTitle,       SIGNAL('editingFinished()'),    self, SLOT('validateTitle()'))
    Qt::Object.connect(@docText,        SIGNAL('textChanged()'),        self, SLOT('updateText()'))
    Qt::Object.connect(@actionLink,     SIGNAL('triggered()'),          self, SLOT('linkDocument()'))
#    Qt::Object.connect(self,            SIGNAL('referenceFound()'),     self, SLOT('insertReference()'))
#    Qt::Object.connect(@docText,        SIGNAL('anchorClicked(QUrl)'),  self, SLOT('linkClicked(QUrl)'))

    self.updateTitle()
  end

  def updateTitle()
    if @docTitle.text.length == 0
      setWindowTitle('Notes')
    else
      setWindowTitle('Notes' + ' [' + @docTitle.text + ']')
      @docText.documentTitle = @docTitle.text
    end
  end

  def validateTitle()
    if @docTitle.text.length == 0
      @docTitle.text = 'newDocument'
      self.updateTitle()
    end
  end

  def updateText()
=begin
    @project.documents.each { |doc|
      if doc.title == @docTitle.text
        next
      end

      puts @docText.toHtml()
      puts "Looking for #{doc.title}"
      index = @docText.toHtml().index(/(?!\<a\shref=\'.*\')(?!\')#{doc.title}(?!\')(?!\<\/a\>)/)
      if index != nil
        puts "Found!"
#       emit referenceFound()
      end
    }
=end
    @document.html = @docText.toHtml()

    if @document.save?()
      @document.save!()
    end
  end
=begin
  def insertReference()
    puts "Insert!"
    @project.documents.each { |doc|
      if doc.title == @docTitle.text
        next
      end

      @docText.html = @docText.toHtml().sub(/(?!\<a\shref=\'.*\')(?!\')#{doc.title}(?!\')(?!\<\/a\>)/, "<a href='#{doc.title}'>#{doc.title}</a>")
    }
  end
=end
  def linkDocument()
    selectedText = @docText.textCursor().selectedText()

    if not selectedText.empty?
      self.updateSelection()

      newWindow = Window.new(@project, Document.new(@project, selectedText))
      newWindow.show()
    else
      puts "You must select something to link!"
    end
  end

  def updateSelection()
    textCursor = @docText.textCursor()

    if textCursor.hasSelection()
      selectedText = textCursor.selectedText()

      textCursor.removeSelectedText()
      textCursor.insertHtml("<a href='#{selectedText}'>#{selectedText}</a>")

      @docText.textCursor = textCursor
    else
      puts "updateSelection(): Nothing to update!"
    end
  end
=begin
  def linkClicked(qurl)
    document = File.new(qurl, 'a')
    newWindow = Window.new(@project, Document.new(@project, document))
    newWindow.show()
  end
=end
end
