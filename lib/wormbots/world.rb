class World
  CARDINALITY = { up: [0, -1], down: [0, 1], left: [-1, 0], right: [1,0] }
  DIRECTIONS = CARDINALITY.keys
  MAX_X = 640 - 4 # horizontal size
  MAX_Y = 480 - 4 # vertical size

  def initialize
    @worms = []
  end

  def spawn_worm
    @worms << Worm.new(starting_point, starting_direction)
  end

  def tick
    data = []
    @worms.each {|worm| data.concat(worm.live)}
    data
  end

  def self.restricted_directions(point)
    restricted = []
    x, y = point

    if left_edge_reached?(x)
      restricted << :left
    elsif right_edge_reached?(x)
      restricted << :right
    end

    if top_edge_reached?(y)
      restricted << :up
    elsif bottom_edge_reached?(y)
      restricted << :down
    end

    restricted
  end

  def self.left_edge_reached?(coord)
    coord <= 0
  end

  def self.right_edge_reached?(coord)
    coord >= MAX_X
  end

  def self.top_edge_reached?(coord)
    coord <= 0
  end

  def self.bottom_edge_reached?(coord)
    coord >= MAX_Y
  end

  private

  def starting_point
    [Kernel.rand(MAX_X), Kernel.rand(MAX_Y)]
  end

  def starting_direction
    DIRECTIONS[Kernel.rand(4)]
  end

end
