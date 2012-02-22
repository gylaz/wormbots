class Worm
  attr_accessor :points, :direction, :age

  def initialize(starting_point, direction)
    @age = 0
    @direction = direction
    @points = [starting_point]
    3.times { @points << append_point }
  end

  def live
    @age += 1
    grow
    move

    points
  end

  def move
    @direction = weighted_possibilities.shuffle[rand(weighted_possibilities.size)]
    self.send("move_#{direction}")
  end

  def weighted_possibilities
    if possible_directions.include? @direction
      possible_directions + 20.times.map { @direction }
    else
      possible_directions
    end
  end

  def grow
    if @age % 10 == 0 && points.size < 40
      @points << append_point
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
    ::World::DIRECTIONS - restrictions - ::World.edges_reached(head)
  end

  def math
    ::World::CARDINALITY[direction.to_sym]
  end

  def append_point
    [tail.first - math.first, tail.last - math.last]
  end

  def prepend_point
    [head.first + math.first, head.last + math.last]
  end

  def head
    points.first
  end

  def tail
    points.last
  end

  ::World::DIRECTIONS.each do |direction|
    define_method "move_#{direction}" do
      points.unshift(prepend_point)
      points.pop
    end
  end
end
