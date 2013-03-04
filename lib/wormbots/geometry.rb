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

  def self.intersecting_worms(world, worm)
    other_worms = world.worms - [ worm ]
    other_worms.select do |other_worm|
      intersection_between_worms(worm, other_worm)
    end
  end

  def self.intersection_between_worms(worm, other_worm)
    points = other_worm.points.map { |point| [point.x, point.y] }
    shared = points & worm.points.map { |point| [point.x, point.y] }
    shared.first
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
