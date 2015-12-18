require 'wormbots/worm'
require 'wormbots/geometry'
require 'wormbots/navigation'
require 'wormbots/mating'
require 'wormbots/point'

class World
  INITIAL_WORMS = 10
  attr_reader :worms, :start_time

  def initialize
    @start_time = Time.now
    @worms = []
  end

  def populate
    @worms = INITIAL_WORMS.times.map { spawn_worm }
  end

  def tick
    @worms.each do |worm|
      worm.live
      attempt_to_mate(worm)
    end

    @worms.reject!(&:decomposed)
  end

  def data_points
    @worms.map do |worm|
      {
        alive: worm.alive?,
        fertile: worm.fertile?,
        points: worm.coordinates.map(&:to_json)
      }
    end
  end

  private

  def attempt_to_mate(worm)
    intersection_coordinates = Mating.new(worm, @worms).intersection_coordinates

    if intersection_coordinates
      spawn_offsprings(intersection_coordinates)
      worm.defertilize
    end
  end

  def spawn_offsprings(coordinates)
    rand(1..4).times do
      @worms << spawn_worm(coordinates)
    end
  end

  def spawn_worm(coordinates = Geometry.random_coordinate)
    point = Point.new(coordinates[0], coordinates[1], true)
    Worm.new(point, Navigation.random_direction)
  end
end
