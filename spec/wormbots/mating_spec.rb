require 'wormbots/mating'

describe Mating, '#intersection_coordinates' do
  context 'when two fertile worms intersect' do
    it 'returns the interecting coordinates' do
      mating = mating_factory([
        { fertile?: true, coordinates: [[1, 1], [1, 2], [1, 3]] },
        { fertile?: true, coordinates: [[1, 3], [2, 3], [3, 3]] }
      ])

      result = mating.intersection_coordinates

      expect(result.to_a).to eq [1, 3]
    end
  end

  context 'when one of the intersecting worms is not fertile' do
    it 'returns nil' do
      mating = mating_factory([
        { fertile?: true, coordinates: [[1, 1], [1, 2], [1, 3]] },
        { fertile?: false, coordinates: [[1, 3], [2, 3], [3, 3]] }
      ])

      result = mating.intersection_coordinates

      expect(result).to eq nil
    end
  end

  context 'when two fertile worms do not intersect' do
    it 'returns nil' do
      mating = mating_factory([
        { fertile?: true, coordinates: [[1, 1], [1, 2], [1, 3]] },
        { fertile?: true, coordinates: [[2, 4], [2, 3], [3, 3]] }
      ])

      result = mating.intersection_coordinates

      expect(result).to eq nil
    end
  end

  def mating_factory(worms)
    world_worms = worms.map do |worm_attributes|
      coords = worm_attributes[:coordinates].map do |coord|
        Point.new(coord.first, coord.last)
      end
      instance_double('Worm', worm_attributes.merge(coordinates: coords))
    end
    Mating.new(world_worms.first, world_worms)
  end
end
