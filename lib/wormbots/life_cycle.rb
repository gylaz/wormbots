require 'wormbots/navigation'
require 'wormbots/point_calculator'

class LifeCycle
  DECAY_DAYS = 100
  INITIAL_SIZE = 4

  def initialize(worm)
    @worm = worm
    (INITIAL_SIZE - 1).times { grow }
  end

  def tick
    if @worm.alive?
      simulate_day
    else
      decay_dead_body
    end
  end

  private

  def simulate_day
    if @worm.max_size?
      kill_off_worm
    else
      @worm.increment_age
      attempt_to_grow
      move
    end
  end

  def decay_dead_body
    @decay_counter ||= DECAY_DAYS
    @decay_counter -= 1

    if @decay_counter == 0
      @worm.decompose
    end
  end

  def attempt_to_grow
    if @worm.can_grow?
      grow
    end
  end

  def grow
    calculator = PointCalculator.new(@worm.tail, @worm.direction)
    @worm.coordinates << calculator.point_behind
  end

  def kill_off_worm
    @worm.die
    @decay_counter = DECAY_DAYS
  end

  def move
    direction = Navigation.new(@worm.direction, @worm.head).direction
    send("move_#{direction}")
  end

  Navigation::DIRECTIONS.each do |direction|
    define_method "move_#{direction}" do
      calculator = PointCalculator.new(@worm.head, direction)
      @worm.coordinates[0].head = false
      @worm.coordinates.unshift(calculator.point_ahead)
      @worm.coordinates.pop
      @worm.direction = direction
    end
  end
end
