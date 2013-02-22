require 'wormbots'

describe Geometry do
  let(:world) { World.new }
  let(:worm1) { Worm.new(world, [2, 2], :up) }
  let(:worm2) { Worm.new(world, [200, 2], :down) }
  let(:worm3) { Worm.new(world, [2, 2], :left) }

  before { world.worms.clear }

  describe ".worm_intersection" do
    it "returns intersection coordinates" do
      world.worms.push(worm1, worm3)
      Geometry.worm_intersection(world, worm1).should == [[2, 2]]
    end
  end

  describe ".worm_intersection_exists?" do
    it "returns true when two worms overlap" do
      world.worms.push(worm1, worm3)
      Geometry.worm_intersection_exists?(world, worm1).should be true
    end

    it "returns false when no worms overlap" do
      world.worms.push(worm1, worm2)
      Geometry.worm_intersection_exists?(world, worm2).should be false
    end
  end

  describe ".random_direction" do
    it "returns a valid random direction" do
      Geometry::DIRECTIONS.should include(Geometry.random_direction)
    end
  end

  describe ".restricted_directions" do
    it "returns up restriction" do
      Geometry.restricted_directions(Point.new(500, 0)).should == [:up]
    end

    it "returns left restriction" do
      Geometry.restricted_directions(Point.new(0, 475)).should == [:left]
    end

    it "returns right restriction" do
      Geometry.restricted_directions(Point.new(636, 475)).should == [:right]
    end

    it "returns down restriction" do
      Geometry.restricted_directions(Point.new(635, 476)).should == [:down]
    end

    it "returns up and left restrictions" do
      Geometry.restricted_directions(Point.new(0, 0)).should == [:left, :up]
    end

    it "returns up and right restrictions" do
      Geometry.restricted_directions(Point.new(636, 0)).should == [:right, :up]
    end

    it "returns down and right restrictions" do
      Geometry.restricted_directions(Point.new(636,476)).should == [:right, :down]
    end
  end

end
