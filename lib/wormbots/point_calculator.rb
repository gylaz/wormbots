class PointCalculator
  CARDINALITY = {
    up:    { x: 0,  y: -1 },
    down:  { x: 0,  y: 1 },
    left:  { x: -1, y: 0 },
    right: { x: 1,  y: 0 }
  }

  def initialize(point, direction)
    @x = point.x
    @y = point.y
    @direction = direction
  end

  def point_ahead
    new_x = @x + addend[:x]
    new_y = @y + addend[:y]
    Point.new(new_x, new_y, true)
  end

  def point_behind
    new_x = @x - addend[:x]
    new_y = @y - addend[:y]
    Point.new(new_x, new_y)
  end

  private

  def addend
    CARDINALITY[@direction]
  end
end
