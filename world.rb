class World

  CARDINALITY = { up: [0, -1], down: [0, 1], left: [-1, 0], right: [1,0] }
  DIRECTIONS = CARDINALITY.keys
  MAX_X = 320 # horizontal size
  MAX_Y = 240 # vertical size

  def initialize
    @worms = []
  end

  def spawn_worm
    @worms << Worm.new(starting_point, starting_direction)
  end

  def tick
    @worms.map(&:live)
  end

  def starting_point
    [Kernel.rand(MAX_X), Kernel.rand(MAX_Y)]
  end

  def starting_direction
    DIRECTIONS[Kernel.rand(4)]
  end

  def self.edges_reached(point)
    edges = []
    x, y = point
    if x == 0
      edges << :left
    elsif x == MAX_X
      edges << :right
    end

    if y == 0
      edges << :up
    elsif y == MAX_Y
      edges << :down
    end
    edges
  end

end
