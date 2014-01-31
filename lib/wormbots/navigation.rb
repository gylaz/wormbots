require 'wormbots/geometry'

class Navigation
  DIRECTIONS = [:up, :down, :left, :right]

  def initialize(direction, coordinates)
    @direction = direction
    @x = coordinates[0]
    @y = coordinates[1]
  end

  def self.random_direction
    DIRECTIONS[Kernel.rand(DIRECTIONS.size)]
  end

  def direction
    available_directions = weighted_available_directions
    available_directions.shuffle[rand(available_directions.size)]
  end

  private

  def weighted_available_directions
    if possible_directions.include?(@direction)
      possible_directions + [@direction] * 15
    else
      possible_directions
    end
  end

  def possible_directions
    @possible_directions ||=
      DIRECTIONS - (restricted_directions << opposite_direction)
  end

  def opposite_direction
    case @direction
    when :up
      :down
    when :down
      :up
    when :left
      :right
    when :right
      :left
    end
  end

  def restricted_directions
    restricted = []

    if Geometry.left_edge_reached?(@x)
      restricted << :left
    elsif Geometry.right_edge_reached?(@x)
      restricted << :right
    end

    if Geometry.top_edge_reached?(@y)
      restricted << :up
    elsif Geometry.bottom_edge_reached?(@y)
      restricted << :down
    end

    restricted
  end
end
