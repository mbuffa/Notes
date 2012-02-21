require 'Qt4'

module Notes
  class Document < Qt::TextDocument
    attr_accessor :title, :filename, :path

    def initialize(project, title = 'newDocument')
      super()

      @project    = project
      @title      = title
      @filename   = title + ".html"
      @path       = File.join(@project.path, @filename)
      @file       = nil

      self.load()
      self.save!()
      @project.add(self)
    end

    def destroy
      @project.rm(self)
    end

    def save?
      if not File.exists?(@path)
        return true
      end

      @file = File.new(@path, "r")
      mtime = File.mtime(@file)
      now   = Time.new()

      # 20.0 seconds is way too big.
      if (now - mtime) > 5.0
        puts "Document.save?(): #{@path} needs update!"
        return true
      else
        return false
      end
      @file.close()
    end

    def save
      puts "Document.save!(): Writing #{@path}"
      @file = File.new(@path, "w+")
      @file.write(self.toHtml())
      @file.close()
    end

    def load
      if File.exists?(@path)
        puts "Document.new(): #{@path} already exists"

        if File.writable?(@path)
          @file = File.new(@path, "a+")
          puts "Document.load(): Loading #{@path}"
          self.html = @file.read()
        else
          raise("Document.new(): #{@path} cannot be overwritten")
        end
      end
    end
  end
end
