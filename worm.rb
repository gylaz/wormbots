class Worm
  attr_accessor :coords, :direction, :size

  CARDINALITY = { up: [0, 1], down: [0, -1], left: [-1, 0], right: [1,0] }
  DIRECTIONS = CARDINALITY.keys

  def initialize
    @age = 0
    @size = 4
    @direction = randomize_direction
    @coords = initial_coords
  end

  def live
    grow if @age % 10 == 0
    move
    @age += 1
  end

  def move
    self.send("move_#{possible_directions[rand(3)]}")
  end

  def grow
    @size += 1
    @coords << calculate_point(@coords.last)
  end

  def data
    [@size, @coords]
  end

  def calculate_point(ref=nil)
    if ref
      math = CARDINALITY[direction.to_sym]
      [ref.first + math.first, ref.last + math.last]
    else
      [rand(640-2), rand(480-2)]
    end
  end

  def randomize_direction
    DIRECTIONS[rand(4)]
  end

  def initial_coords
    coords = []
    @size.times do
      coords << calculate_point(coords.last)
    end
    coords
  end

  def possible_directions
    case direction
    when :up
      DIRECTIONS - [:down]
    when :down
      DIRECTIONS - [:up]
    when :left
      DIRECTIONS - [:right]
    when :right
      DIRECTIONS - [:left]
    end
  end

  DIRECTIONS.each do |direction|
    define_method "move_#{direction}" do
      coords.each do |coord|
        math = CARDINALITY[direction.to_sym]
        coord.first += math.first
        coord.last += math.last
      end
    end
  end
end