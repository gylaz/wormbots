require 'wormbots/point'
require 'wormbots/worm'
require 'wormbots/life_cycle'

describe LifeCycle, '#initialize' do
  it 'grows the worm' do
    worm = Worm.new(Point.new(1, 1), :down)

    LifeCycle.new(worm)

    expect(worm.coordinates.size).to eq LifeCycle::INITIAL_SIZE
  end
end

describe LifeCycle, '#tick' do
  let(:worm) { Worm.new(Point.new(1, 1), :down) }
  let!(:life_cycle) { LifeCycle.new(worm) }

  context 'when worm is alive' do
    it 'increments the age of worm' do
      worm.stub(:increment_age)

      life_cycle.tick

      expect(worm).to have_received(:increment_age)
    end

    it 'moves the worm' do
      Navigation.stub_chain(:new, :direction).and_return(:right)
      worm.stub(:move_right)

      expect { life_cycle.tick }.not_to change { worm.size }

      expect(worm.direction).to eq :right
      expect([worm.head.x, worm.head.y]).to eq [2, 1]
    end

    context 'when worm should grow' do
      it 'increases the size of worm' do
        worm.stub(can_grow?: true)

        expect { life_cycle.tick }.to change { worm.size }.by(1)
      end
    end

    context 'when worm should not grow' do
      it 'does not increase the size of worm' do
        worm.stub(can_grow?: false)

        expect { life_cycle.tick }.not_to change { worm.size }
      end
    end

    context 'when worm is max size' do
      it 'kills worm' do
        worm.stub(max_size?: true)
        worm.stub(:die)

        life_cycle.tick

        expect(worm).to have_received(:die)
      end
    end
  end

  context 'when worm is dead' do
    context 'when body is decaying' do
      it 'does not decompose worm' do
        worm.stub(alive?: false)
        worm.stub(:decompose)

        life_cycle.tick

        expect(worm).not_to have_received(:decompose)
      end
    end

    context 'when body has finished decaying' do
      it 'decomposes worm' do
        worm.stub(alive?: false)
        worm.stub(:decompose)

        LifeCycle::DECAY_DAYS.times { life_cycle.tick }

        expect(worm).to have_received(:decompose)
      end
    end
  end
end
