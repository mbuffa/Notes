require 'Qt4'

class Window < Qt::Dialog
  attr_reader :document
  slots 'updateTitle()'
  slots 'validateTitle()'
  slots 'updateText()'
  slots 'linkDocument()'

  def initialize(project, document)
    super()

    @project     = project
    @document    = document

    #
    # Tool Bar instanciation
    #
    @toolBar            = Qt::ToolBar.new()

    @actionProject      = Qt::Action.new(self)
    @actionProject.setText(@project.title)

    @actionLink         = Qt::Action.new(self)
    @actionLink.setText('Link')

    @toolBar.addAction(@actionProject)
    @toolBar.addAction(@actionLink)

    #
    # Text Fields instanciation
    #
    @docTitle   = Qt::LineEdit.new()
    @docTitle.setText(@document.title)
    @docText    = Qt::TextEdit.new()

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
    connect(@docTitle,   SIGNAL('textChanged(const QString &)'), self,  SLOT('updateTitle()'))
    connect(@docTitle,   SIGNAL('editingFinished()'),            self,  SLOT('validateTitle()'))
    connect(@docText,    SIGNAL('textChanged()'),                self,  SLOT('updateText()'))
    connect(@actionLink, SIGNAL('triggered()'),                  self,  SLOT('linkDocument()'))

    self.updateTitle()
  end

  def updateTitle()
    if @docTitle.text.length == 0
      setWindowTitle('Notes')
    else
      setWindowTitle('Notes' + ' [' + @docTitle.text + ']')
    end
  end

  def validateTitle()
    if @docTitle.text.length == 0
      @docTitle.text = 'newDocument'
      self.updateTitle()
    end
  end

  def updateText()
    @document.text = @docText.toPlainText()

    if @document.save?()
      @document.save!()
    end
  end

  def linkDocument()
    $qApp.clipboard.clear()
    @docText.copy()
    selectedText = $qApp.clipboard.text()
    newWindow = Window.new(@project, Document.new(@project, selectedText))
    newWindow.show()
    @document.linkTo(selectedText, newWindow.document)
  end
end
