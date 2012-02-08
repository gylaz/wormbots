class Worm
  attr_accessor :x, :y

  def initialize
  	@x = rand(640-2)
    @y = rand(480-2)
    @age = 0
    @size = 8
  end

  def live
    move
    grow if @age % 10 == 0
    @age += 1
  end

  def move
    case rand(2)
    when 0
      move_x
    when 1
	    move_y
    end
  end

  def move_x
    if @x == 640 - 2
      move_y
    else
      @x += 1
    end
  end

  def move_y
    if @y == 480 - 2
      move_x
    else
      @y += 1
    end
  end

  def grow
    @size += 1
  end

  def coords
    [x, y]
  end

  def data
    #puts coords
    coords << @size
  end
end