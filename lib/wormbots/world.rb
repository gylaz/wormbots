require 'wormbots/worm'
require 'wormbots/geometry'
require 'wormbots/navigation'
require 'wormbots/mating'

class World
  INITIAL_WORMS = 10
  attr_reader :worms, :start_time

  def initialize
    @start_time = Time.now
    @worms = []
  end

  def populate
    INITIAL_WORMS.times { spawn_worm }
  end

  def tick
    @worms.dup.each do |worm|
      worm.live
      attempt_to_mate(worm)

      if worm.decomposed
        @worms.delete(worm)
      end
    end
  end

  def data_points
    @worms.map do |worm|
      {
        alive: worm.alive?,
        fertile: worm.fertile?,
        points: worm.coordinates
      }
    end
  end

  private

  def attempt_to_mate(worm)
    intersection_coordinates = Mating.new(worm, @worms).intersection_coordinates
    if intersection_coordinates
      rand(1..4).times { spawn_worm(intersection_coordinates) }
      worm.defertilize
    end
  end

  def spawn_worm(coords = nil)
    coordinates = coords || Geometry.random_coordinate
    worm = Worm.new(coordinates, Navigation.random_direction)
    @worms << worm
    worm
  end
end
