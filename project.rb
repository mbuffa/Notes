class Project
  attr_accessor :title, :documents

  def initialize(title)
    @title      = title
    @documents  = []

    puts "Dir.mkdir(#{title})."
  end

  def add(document)
    @documents.push(document)
  end

  def rm(document)
    @documents.delete(document)
  end
end
