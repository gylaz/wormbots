require 'wormbots'

describe World, '#populate' do
  it 'spawns 10 worms' do
    world = world_factory
    world.populate

    expect(world).to have(10).worms
  end
end

describe World, '#tick' do
  it 'calls live on every worms' do
    worm1 = worm_factory
    worm2 = worm_factory
    world = world_factory(worm1, worm2)

    world.tick

    expect(worm1).to have_received(:live)
    expect(worm2).to have_received(:live)
  end

  context 'when two worms can be mated' do
    it 'mates worms' do
      worm1 = worm_factory(coordinates: [[10, 10]])
      worm2 = worm_factory(coordinates: [[10, 10]])
      world = world_factory(worm1, worm2)

      expect { world.tick }.to change { world.worms.size }

      expect(worm1).to have_received(:defertilize)
      expect(worm2).to have_received(:defertilize)
    end
  end

  context 'when worm has been marked for removal' do
    it 'removes worm' do
      worm1 = worm_factory(decomposed: true)
      world = world_factory(worm1)

      world.tick

      expect(world).to have(0).worms
    end
  end

  context 'after 4000 ticks' do
    it 'simulates a period of worm lives' do
      world = world_factory
      world.populate

      4000.times { world.tick }

      expect(world.worms.size).to be > World::INITIAL_WORMS
      world.worms.each do |worm|
        worm.coordinates.each do |x, y|
          expect(x).to be >= 0
          expect(y).to be >= 0
          expect(x).to be <= Geometry::MAX_X
          expect(y).to be <= Geometry::MAX_Y
        end
      end
    end
  end
end

describe World, '#data_points' do
  it 'returns worm data' do
    world = World.new
    world.populate
    worm = world.worms.first

    expect(world).to have(10).data_points
    expect(world.data_points.first).to eq(
      alive: true,
      fertile: false,
      points: worm.coordinates
    )
  end
end

def world_factory(*worms)
  world = World.new
  worms.each { |worm| world.worms << worm }
  world
end

def worm_factory(attributes = {})
  default_attributes = {
    live: nil,
    fertile?: true,
    decomposed: false,
    defertilize: nil,
    coordinates: []
  }
  double(:worm, default_attributes.merge(attributes))
end
