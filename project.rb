class Project
  attr_accessor :title, :docs

  def initialize(title = "newProject")
    @title      = title
    @docs       = []
  end

  def add(doc)
    @docs.push(doc)
  end

  def rm(doc)
    @docs.delete(doc)
  end
end
