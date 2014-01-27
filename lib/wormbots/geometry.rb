module Geometry
  MIN_X = 0
  MIN_Y = 0
  MAX_X = 640 - 4 # horizontal limit
  MAX_Y = 480 - 4 # vertical limit

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

  def self.random_coordinate
    [Kernel.rand(MAX_X), Kernel.rand(MAX_Y)]
  end
end
