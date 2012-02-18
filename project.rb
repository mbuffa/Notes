module Notes
  class Project
    attr_accessor :title, :documents
    attr_reader :path

    def initialize(title, path)
      @title     = title
      @documents = []
      @path      = File.join(path, @title)

#      puts "Dir.mkdir(#{path})"
      Dir.mkdir(@path)
    end

    def add(document)
      @documents.push(document)
    end

    def rm(document)
      @documents.delete(document)
    end
  end
end
