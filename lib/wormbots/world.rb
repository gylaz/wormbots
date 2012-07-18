class World
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

  def spawn_worm(coords = nil)
    @worms << Worm.new(coords || Geometry.random_point, Geometry.random_direction)
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

  private

  def time_diff_in_millis(t1, t2)
    ((t1 - t2) * 10).to_i
  end
end
