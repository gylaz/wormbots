class Worm
  UNIT_SIZE = 1
  MAX_SIZE = 40
  CARDINALITY = { up:    { x: 0,  y: -1 },
                  down:  { x: 0,  y: 1 },
                  left:  { x: -1, y: 0 },
                  right: { x: 1,  y: 0 } }

  attr_accessor :points, :direction, :age

  def initialize(starting_coords, direction)
    @age = 0
    @direction = direction
    @points = [Point.new(*starting_coords)]
    3.times { append_point }
  end

  def live(days)
    days.times do
      @age += 1
      grow if time_to_grow?
      move
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
      possible_directions + 10.times.map { @direction }
    else
      possible_directions
    end
  end

  def grow
    append_point
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
    ::World::DIRECTIONS - restrictions - ::World.restricted_directions(head)
  end

  def math
    CARDINALITY[direction.to_sym]
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

  ::World::DIRECTIONS.each do |direction|
    define_method "move_#{direction}" do
      prepend_point
      points.pop
    end
  end

  private

  def time_to_grow?
    @age % 10 == 0 && points.size < MAX_SIZE
  end
end
