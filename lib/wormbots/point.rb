class Point < Struct.new(:x, :y, :head)
  def ==(obj)
    to_a == obj.to_a
  end

  def to_a
    [x, y]
  end

  def to_json
    { x: x, y: y, head: head }
  end
end
