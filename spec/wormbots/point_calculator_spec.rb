require 'wormbots/point'
require 'wormbots/point_calculator'

describe PointCalculator, '#point_ahead' do
  specify { expect(calculator(:up).point_ahead).to eq [100, 199] }
  specify { expect(calculator(:down).point_ahead).to eq [100, 201] }
  specify { expect(calculator(:left).point_ahead).to eq [99, 200] }
  specify { expect(calculator(:right).point_ahead).to eq [101, 200] }
end

describe PointCalculator, '#point_behind' do
  specify { expect(calculator(:up).point_behind).to eq [100, 201] }
  specify { expect(calculator(:down).point_behind).to eq [100, 199] }
  specify { expect(calculator(:left).point_behind).to eq [101, 200] }
  specify { expect(calculator(:right).point_behind).to eq [99, 200] }
end

def calculator(direction)
  PointCalculator.new(Point.new(100, 200), direction)
end
