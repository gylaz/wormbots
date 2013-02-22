module Geometry
  DIRECTIONS = [:up, :down, :left, :right]
  MAX_X = 640 - 4 # horizontal limit
  MAX_Y = 480 - 4 # vertical limit
  CARDINALITY = {
    up:    { x: 0,  y: -1 },
    down:  { x: 0,  y: 1 },
    left:  { x: -1, y: 0 },
    right: { x: 1,  y: 0 }
  }

  def self.worm_intersection(world, worm)
    worms = world.worms - [ worm ]
    all_worms_points = worms.map(&:points).flatten.map {|p| [p.x, p.y] }
    all_worms_points & worm.points.map {|p| [p.x, p.y] }
  end

  def self.worm_intersection_exists?(world, worm)
    !worm_intersection(world, worm).empty?
  end

  def self.restricted_directions(point)
    restricted = []

    if left_edge_reached?(point.x)
      restricted << :left
    elsif right_edge_reached?(point.x)
      restricted << :right
    end

    if top_edge_reached?(point.y)
      restricted << :up
    elsif bottom_edge_reached?(point.y)
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

  def self.random_direction
    DIRECTIONS[Kernel.rand(4)]
  end

  def self.random_point
    [Kernel.rand(MAX_X), Kernel.rand(MAX_Y)]
  end
end
