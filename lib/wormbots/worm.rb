class Worm
  UNIT_SIZE = 1
  MAX_SIZE = 60
  MATING_AGE = 18

  attr_accessor :points, :direction, :age

  def initialize(world, starting_coords, direction)
    @world = world
    @alive = true
    @age = 0
    @direction = direction
    @points = [Point.new(*starting_coords)]
    3.times { append_point }
  end

  def live(days)
    days.times do
      if alive?
        self.age += 1

        if time_to_die?
          die
        else
          attempt_to_mate
          if time_to_grow?
            grow
          end
          move
        end
      else
        @cleanup_time += 1
        cleanup_dead_body if @cleanup_time >= 20
      end
    end
  end

  def move
    @direction = weighted_possibilities.shuffle[rand(weighted_possibilities.size)]
    self.send("move_#{direction}")
  end

  def coordinates
    points.map { |p| [p.x, p.y] }
  end

  def weighted_possibilities
    if possible_directions.include? @direction
      possible_directions + 15.times.map { @direction }
    else
      possible_directions
    end
  end

  def grow
    append_point
  end

  def die
    @alive = false
    @cleanup_time = 0
  end

  def attempt_to_mate
    if fertile?
      mate
    end
  end

  def mate
    potential_matches = Geometry.intersecting_worms(@world, self)
    match = potential_matches.detect { |worm| worm.fertile? }

    if match
      coords = Geometry.intersection_between_worms(self, match)
      rand(1..4).times { @world.spawn_worm(coords) }
      @mating_cooldown = 20
    end
  end

  def fertile?
    if @mating_cooldown && @mating_cooldown > 0
      @mating_cooldown -= 1
      false
    else
      alive? && adult?
    end
  end

  def possible_directions
    case direction
    when :up
      restrictions = [:down]
    when :down
      restrictions = [:up]
    when :left
      restrictions = [:right]
    when :right
      restrictions = [:left]
    end
    ::Geometry::DIRECTIONS - restrictions - ::Geometry.restricted_directions(head)
  end

  def math
    ::Geometry::CARDINALITY[direction.to_sym]
  end

  def append_point
    new_x = tail.x - math[:x]
    new_y = tail.y - math[:y]
    points << Point.new(new_x, new_y)
  end

  def prepend_point
    new_x = head.x + math[:x]
    new_y = head.y + math[:y]
    points.unshift Point.new(new_x, new_y)
  end

  def head
    points.first
  end

  def tail
    points.last
  end

  def moving_horizontally?
    [:left, :right].include?(direction)
  end

  def moving_vertically?
    [:up, :down].include?(direction)
  end

  ::Geometry::DIRECTIONS.each do |direction|
    define_method "move_#{direction}" do
      prepend_point
      points.pop
    end
  end

  def alive?
    @alive
  end

  def adult?
    size >= MATING_AGE
  end

  private

  def cleanup_dead_body
    @world.worms.delete(self)
  end

  def time_to_die?
    size >= MAX_SIZE
  end

  def time_to_grow?
    @age % 100 == 0 && size < MAX_SIZE
  end

  def size
    points.size
  end
end
