class World
  DIRECTIONS = [:up, :down, :left, :right]
  MAX_X = 640 - 4 # horizontal limit
  MAX_Y = 480 - 4 # vertical limit

  def initialize
    @worms = []
    10.times { spawn_worm }
  end

  def fiber_loop
    @fiber_loop ||= Fiber.new {
      loop do
        tick
        Fiber.yield data_points
      end
    }
  end

  def spawn_worm
    @worms << Worm.new(starting_point, starting_direction)
  end

  def tick
    now_secs = Time.now.to_i
    days = @last_update ? @last_update - now_secs : 0
    @last_update = now_secs

    @worms.each { |worm| worm.live(days) }
  end

  def data_points
    @worms.map { |worm| worm.coordinates }
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

  private

  def starting_point
    [Kernel.rand(MAX_X), Kernel.rand(MAX_Y)]
  end

  def starting_direction
    DIRECTIONS[Kernel.rand(4)]
  end

end
