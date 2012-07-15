class World
  DIRECTIONS = [:up, :down, :left, :right]
  MAX_X = 640 - 4 # horizontal limit
  MAX_Y = 480 - 4 # vertical limit

  attr_reader :worms

  def initialize
    @worms = []
    10.times { spawn_worm }
    @last_update = Time.now
  end

  def fiber
    @fiber ||= Fiber.new {
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
    now = Time.now
    days = time_diff_in_millis(now, @last_update)

    if days > 0 
      @worms.each { |worm| worm.live(days) }
      @last_update = now
    end
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

  def time_diff_in_millis(t1, t2)
    ((t1 - t2) * 10).to_i
  end

  def starting_point
    [Kernel.rand(MAX_X), Kernel.rand(MAX_Y)]
  end

  def starting_direction
    DIRECTIONS[Kernel.rand(4)]
  end

end
