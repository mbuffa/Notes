class Link
  attr_accessor :pos, :len, :doc

  def initialize(pos = nil, len = nil, doc = nil)
    @pos        = pos
    @len        = len
    @doc        = doc
  end
end
