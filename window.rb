require 'Qt4'

module Notes
  class Window < Qt::Dialog
    attr_reader :document
    slots 'updateTitle()', 'validateTitle()', 'updateText()', 'linkDocument()', 'linkClicked(QUrl)'

    def initialize(project, document, parentWindow = nil)
      super()

      @project    = project
      @document   = document
      @parent     = parentWindow

      #
      # Tool Bar instanciation
      #
      @toolBar            = Qt::ToolBar.new()

      @actionProject      = Qt::Action.new(self)
      @actionProject.text = @project.title

      @actionLink         = Qt::Action.new(self)
      @actionLink.text = '&Link'

      @toolBar.addAction(@actionProject)
      @toolBar.addAction(@actionLink)

      #
      # Text Fields instanciation
      #
      @docTitle           = Qt::LineEdit.new()
      @docTitle.text      = @document.title
      @docText            = Qt::TextBrowser.new()
      @docText.readOnly   = false
      @docText.openLinks  = false
      @docText.openExternalLinks = false
      @docText.html       = @document.toHtml()

      #
      # Layout setup
      #
      @layout = Qt::VBoxLayout.new()
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
      Qt::Object.connect(@docText,        SIGNAL('anchorClicked(QUrl)'),  self, SLOT('linkClicked(QUrl)'))

      self.updateTitle()

      if not @parent.nil?
        @docText.html = "<a href='file://#{@project.path}/#{@parent.document.filename}'>Back to #{@parent.document.title}</a>"
      end
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
      @document.html = @docText.toHtml()

      if @document.save?()
        @document.save!()
      end
    end

    def linkDocument()
      selectedText = @docText.textCursor().selectedText()

      if not selectedText.empty?
        newWindow = Notes::Window.new(@project, Notes::Document.new(@project, selectedText), self)
        newWindow.show()

        self.updateSelection()
      else
        puts "linkDocument(): You must select something to link!"
      end
    end

    def updateSelection()
      textCursor = @docText.textCursor()

      if textCursor.hasSelection()
        selectedText = textCursor.selectedText()

        textCursor.removeSelectedText()
        textCursor.insertHtml("<a href='file://#{@project.path}/#{selectedText}.html'>#{selectedText}</a>")

        @docText.textCursor = textCursor
      else
        puts "updateSelection(): Nothing to update!"
      end
    end

    def linkClicked(qurl)
      puts qurl

      document  = File.new(qurl, 'a')
      newWindow = Notes::Window.new(@project, Notes::Document.new(@project, document))
      newWindow.show()
    end
  end
end
