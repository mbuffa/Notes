require 'Qt4'
require File.join('.', 'project.rb')
require File.join('.', 'document.rb')
require File.join('.', 'link.rb')

class NotesWindow < Qt::Dialog
  attr_reader :currentDocument
  slots 'update()'
  slots 'link()'

  def initialize(newProject = 'newProject', newDoc = 'Main')
    super()
    setWindowTitle('Notes')

    buildUI(newProject, newDoc)
    buildProject(newProject, newDoc)
  end

  def buildUI(newProject, newDoc)
    #
    # Menu Bar instanciation
    #
#    @menuBar = Qt::MenuBar.new(self)
#    @menuBar.setObjectName('menuBar')
#
#    @menuFile = Qt::Menu.new(@menuBar)
#    @menuFile.setObjectName('menuFile')
#    @menuFile.setTitle('&File')
#
#    @actionExit = Qt::Action.new(self)
#    @actionExit.setObjectName('actionExit')
#    @actionExit.setText('&Exit')
#
#    @menuFile.addAction(@actionExit)
#
#    connect(@actionExit, SIGNAL('triggered()'), $qApp, SLOT('quit()'))
#
#    @menuBar.addAction(@menuFile.menuAction())
#
    #
    # Tool Bar instanciation
    #
    @toolBar            = Qt::ToolBar.new()

    @actionProject      = Qt::Action.new(self)
    puts newProject.to_s
    @actionProject.setText(newProject)

    @actionLink         = Qt::Action.new(self)
    @actionLink.setText('Link')

    @toolBar.addAction(@actionProject)
    @toolBar.addAction(@actionLink)

    #
    # Text Fields instanciation
    #
    @docTitle   = Qt::LineEdit.new()
    @docTitle.setText(newDoc)
    @docText    = Qt::TextEdit.new()

    #
    # Layout setup
    #
    @layout     = Qt::VBoxLayout.new()
#    @layout.setMenuBar(@menuBar)
    @layout.addWidget(@toolBar)
    @layout.addWidget(@docTitle)
    @layout.addWidget(@docText)
    self.setLayout(@layout)

    #
    # Signal connections
    #
    connect(@docText, SIGNAL('textChanged()'), self, SLOT('update()'))
    connect(@actionLink, SIGNAL('triggered()'), self, SLOT('link()'))
#    connect(@docText, SIGNAL('selectionChanged()'), self, SLOT('link()'))
  end

  def buildProject(newProject, newDoc)
    @currentProject     = Project.new(newProject)
    @currentDocument    = Document.new(@docTitle.text, @docText.toHtml())
    @docText.setDocument(@currentDocument)

    puts "Dir.mkdir(#{@currentProject.title}/)"
    puts "Dir.touch(#{@currentProject.title}/#{@currentDocument.title})"
#    Dir.mkdir(@currentDocument.title)
  end

  def update
#    puts "#{@docText.toPlainText()}"
    @currentDocument.text = @docText.toPlainText()

    if @currentDocument.save?()
      @currentDocument.save!()
    end
  end

  def link
    $qApp.clipboard.clear()
    @docText.copy()
    newDocTitle = $qApp.clipboard.text()
    newDoc      = NotesWindow.new(@currentProject.title, newDocTitle)
    newDoc.show()
    @currentDocument.linkTo(newDocTitle, newDoc.currentDocument)
  end
end

app = Qt::Application.new(ARGV)

window = NotesWindow.new()
window.show()

app.exec()
