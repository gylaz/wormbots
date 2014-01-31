class PointCalculator
  CARDINALITY = {
    up:    { x: 0,  y: -1 },
    down:  { x: 0,  y: 1 },
    left:  { x: -1, y: 0 },
    right: { x: 1,  y: 0 }
  }

  def initialize(coords, direction)
    @x = coords[0]
    @y = coords[1]
    @direction = direction
  end

  def point_ahead
    new_x = @x + addend[:x]
    new_y = @y + addend[:y]
    [new_x, new_y]
  end

  def point_behind
    new_x = @x - addend[:x]
    new_y = @y - addend[:y]
    [new_x, new_y]
  end

  private

  def addend
    CARDINALITY[@direction]
  end
end
