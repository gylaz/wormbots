class World
  attr_reader :worms

  def initialize
    @worms = []
    10.times { spawn_worm }
  end

  def spawn_worm(coords = nil)
    coordinates = coords || Geometry.random_point
    @worms << Worm.new(self, coordinates, Geometry.random_direction)
  end

  def tick
    @worms.each { |worm| worm.live(1) }
  end

  def data_points
    @worms.map { |worm| worm.coordinates }
  end
end
