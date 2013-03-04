require 'wormbots'

describe Geometry do
  let(:world) { World.new }
  let(:worm1) { Worm.new(world, [2, 2], :up) }
  let(:worm2) { Worm.new(world, [200, 2], :down) }
  let(:worm3) { Worm.new(world, [2, 2], :left) }

  before { world.worms.clear }

  describe ".intersecting_worms" do
    it "returns worms that share the same coordinates" do
      world.worms.push(worm1, worm3)
      Geometry.intersecting_worms(world, worm1).should == [worm3]
    end
  end

  describe ".intersection_between_worms" do
    it "returns coordinates that are shared between two worms" do
      Geometry.intersection_between_worms(worm1, worm3).should == [2, 2]
    end

    it "returns nil when no worms overlap" do
      Geometry.intersection_between_worms(worm1, worm2).should be_nil
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
