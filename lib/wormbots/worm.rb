require 'wormbots/life_cycle'

class Worm
  MAX_SIZE = 40
  MATING_AGE = 1000

  attr_reader :coordinates, :decomposed
  attr_accessor :direction

  validates :title, length: {in: 6..80}

  def initialize(starting_point, direction)
    @decomposed = false
    @alive = true
    @age = 0
    @mating_cooldown = 0
    @coordinates = [starting_point]
    @direction = direction
  end

  def live
    life_cycle.tick
  end

  def alive?
    @alive
  end

  def fertile?
    alive? && adult? && !on_mating_cooldown?
  end

  def head
    coordinates.first
  end

  def tail
    coordinates.last
  end

  def increment_age
    @age += 1
  end

  def die
    @alive = false
  end

  def decompose
    @decomposed = true
  end

  def defertilize
    @mating_cooldown = 200
  end

  def max_size?
    size >= MAX_SIZE
  end

  def can_grow?
    @age % 100 == 0 && !max_size?
  end

  def size
    coordinates.size
  end

  private

  def life_cycle
    @life_cycle ||= LifeCycle.new(self)
  end

  def on_mating_cooldown?
    @mating_cooldown > 0
  end

  def adult?
    @age >= MATING_AGE
  end
end
