require 'wormbots/navigation'

describe Navigation do
  describe '.random_direction' do
    it 'returns a valid random direction' do
      expect(Navigation::DIRECTIONS).to include(Navigation.random_direction)
    end
  end

  describe '#direction' do
    context 'when direction is up' do
      it 'returns one of the allowed directions' do
        navigation = Navigation.new(:up, [100, 100])

        expect([:up, :left, :right]).to include navigation.direction
      end

      context 'at top edge' do
        it 'returns right or left' do
          navigation = Navigation.new(:up, [100, 0])

          expect([:left, :right]).to include navigation.direction
        end
      end

      context 'at top left corner' do
        it 'returns right' do
          navigation = Navigation.new(:up, [0, 0])

          expect(navigation.direction).to eq :right
        end
      end

      context 'at top right corner' do
        it 'returns left' do
          navigation = Navigation.new(:up, [Geometry::MAX_X, 0])

          expect(navigation.direction).to eq :left
        end
      end
    end

    context 'when direction is down' do
      it 'returns one of the allowed directions' do
        navigation = Navigation.new(:down, [100, 100])

        expect([:down, :left, :right]).to include navigation.direction
      end

      context 'at bottom edge' do
        it 'returns right or left' do
          navigation = Navigation.new(:down, [100, Geometry::MAX_Y])

          expect([:left, :right]).to include navigation.direction
        end
      end

      context 'at bottom right corner' do
        it 'returns left' do
          navigation = Navigation.new(:down, [Geometry::MAX_X, Geometry::MAX_Y])

          expect(navigation.direction).to eq :left
        end
      end

      context 'at bottom left corner' do
        it 'returns right' do
          navigation = Navigation.new(:down, [0, Geometry::MAX_Y])

          expect(navigation.direction).to eq :right
        end
      end
    end

    context 'when direction is left' do
      it 'returns one of the allowed directions' do
        navigation = Navigation.new(:left, [100, 100])

        expect([:down, :up, :left]).to include navigation.direction
      end

      context 'at left edge' do
        it 'returns up or down' do
          navigation = Navigation.new(:left, [0, 100])

          expect([:up, :down]).to include navigation.direction
        end
      end

      context 'at top left corner' do
        it 'returns down' do
          navigation = Navigation.new(:left, [0, 0])

          expect(navigation.direction).to eq :down
        end
      end

      context 'at bottom left corner' do
        it 'returns up' do
          navigation = Navigation.new(:left, [0, Geometry::MAX_Y])

          expect(navigation.direction).to eq :up
        end
      end
    end

    context 'when direction is right' do
      it 'returns one of the allowed directions' do
        navigation = Navigation.new(:right, [100, 100])

        expect([:down, :up, :right]).to include navigation.direction
      end

      context 'at right edge' do
        it 'returns up or down' do
          navigation = Navigation.new(:right, [Geometry::MAX_X, 100])

          expect([:up, :down]).to include navigation.direction
        end
      end

      context 'at bottom right corner' do
        it 'returns up' do
          navigation = Navigation.new(:right, [Geometry::MAX_X, Geometry::MAX_Y])

          expect(navigation.direction).to eq :up
        end
      end

      context 'at top right corner' do
        it 'returns down' do
          navigation = Navigation.new(:right, [Geometry::MAX_X, 0])

          expect(navigation.direction).to eq :down
        end
      end
    end
  end
end
