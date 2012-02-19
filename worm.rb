require_relative 'world'

class Worm
  attr_accessor :points, :direction, :age

  def initialize(starting_point, direction)
    @age = 0
    @direction = direction
    @points = [starting_point]
    3.times { @points << append_point }
  end

  def live
    grow if @age % 10 == 0
    move
    @age += 1

    points
  end

  def move
    direction = possible_directions[rand(possible_directions.size)]
    self.send("move_#{direction}")
  end

  def grow
    @points << append_point
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
