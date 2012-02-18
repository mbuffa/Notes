require 'Qt4'

module Notes
  class Document < Qt::TextDocument
    attr_accessor :text, :title, :filename

    def initialize(project, title = 'newDocument')
      super()

      @project    = project
      @title      = title
      @filename   = title + ".html"

#      puts "Document.new(#{project.title}, #{title})"
#      puts "File.new(File.join('#{@project.path}', '#{@filename}'), 'a+')"
      File.new(File.join(@project.path, @filename), "a+")

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
end
