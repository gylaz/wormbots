class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def == obj
    self.x == obj.x && self.y == obj.y
  end
end
