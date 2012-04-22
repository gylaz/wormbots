require 'wormbots'

describe World do
  let(:world) { World.new }

  describe "#fiber_loop" do
    it "returns a fiber" do
      world.fiber_loop.should be_an_instance_of Fiber
    end
  end

  describe "#spawn_worm" do
    it "adds a worm isntance to @worms" do
      expect {
        world.spawn_worm
      }.to change {
        world.instance_variable_get("@worms").size
      }.by(1)
    end
  end

  describe "#tick" do
    before { world.spawn_worm }

    it "updates last_update" do
      expect { world.tick }.to change {
        world.instance_variable_get("@last_update") }
    end

    it "lets the worms live" do
      worm = world.instance_variable_get("@worms").first
      worm.should_receive(:live).with(0)
      world.tick
    end
  end

  describe "#data_points" do
    it "returns coordinates for multiple worms" do
      world.spawn_worm
      world.spawn_worm
      world.data_points.should have(12).items
    end
  end
  
  describe "#starting_direction" do
    it "returns a valid starting direction" do
      World::DIRECTIONS.should include(world.send(:starting_direction))
    end
  end

  describe ".restricted_directions" do
    it "returns up restriction" do
      World.restricted_directions(Point.new(500, 0)).should == [:up]
    end

    it "returns left restriction" do
      World.restricted_directions(Point.new(0, 475)).should == [:left]
    end

    it "returns right restriction" do
      World.restricted_directions(Point.new(636, 475)).should == [:right]
    end

    it "returns down restriction" do
      World.restricted_directions(Point.new(635, 476)).should == [:down]
    end

    it "returns up and left restrictions" do
      World.restricted_directions(Point.new(0, 0)).should == [:left, :up]
    end

    it "returns up and right restrictions" do
      World.restricted_directions(Point.new(636, 0)).should == [:right, :up]
    end

    it "returns down and right restrictions" do
      World.restricted_directions(Point.new(636,476)).should == [:right, :down]
    end
  end

end
