module Notes
  class Project
    attr_accessor :title, :documents
    attr_reader :path

    def initialize(title, path)
      @title     = title
      @documents = []
      @path      = File.join(path, @title)

      if File.exists?(@path)
        if File.directory?(@path)
          puts "Project.new(): #{@path} already exists"
        else
          puts "Project.new(): #{@path} is a file, deleting..."
          Dir.delete(@path)
        end
      else
        Dir.mkdir(@path)
      end
    end

    def add(document)
      @documents.push(document)
    end

    def rm(document)
      @documents.delete(document)
    end
  end
end
