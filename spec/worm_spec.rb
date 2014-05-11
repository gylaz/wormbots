require 'wormbots/point'
require 'wormbots/worm'

describe Worm, '#tick' do
  it 'grows to initial size' do
    worm = Worm.new(Point.new(100, 150), :up)

    worm.live

    expect(worm).to have(4).coordinates
  end
end

describe Worm, '#fertile?' do
  let(:worm) { Worm.new(Point.new(100, 150), :up) }

  context 'when over mating age' do
    it 'returns true' do
      Worm::MATING_AGE.times { worm.increment_age }

      expect(worm).to be_fertile
    end

    context 'when on cooldown' do
      it 'returns false' do
        worm.stub(size: Worm::MATING_AGE)
        worm.stub(on_mating_cooldown?: true)

        expect(worm).not_to be_fertile
      end
    end
  end

  context 'when under mating age' do
    it 'returns false' do
      expect(worm).not_to be_fertile
    end
  end

  context 'when dead' do
    it 'returns false' do
      worm.die

      expect(worm).not_to be_fertile
    end
  end
end

describe Worm, '#head' do
  let(:worm) { Worm.new(Point.new(100, 150), :up) }

  it 'returns first coordinate' do
    expect(worm.head.to_a).to eq [100, 150]
  end
end

describe Worm, '#tail' do
  let(:worm) { Worm.new(Point.new(100, 150), :up) }

  it 'returns last coordinate' do
    expect(worm.tail).to eq worm.coordinates.last
  end
end

describe Worm, '#can_grow?' do
  let(:worm) { Worm.new(Point.new(100, 150), :up) }

  context 'when not on 100th tick' do
    it 'returns false' do
      110.times { worm.increment_age }

      expect(worm.can_grow?).to be false
    end
  end

  context 'when on 100th ticks' do
    it 'returns true' do
      100.times { worm.increment_age }

      expect(worm.can_grow?).to be true
    end

    context 'when reached max size' do
      it 'returns false' do
        worm.stub(size: Worm::MAX_SIZE)
        100.times { worm.increment_age }

        expect(worm.can_grow?).to be false
      end
    end
  end
end
