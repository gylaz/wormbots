require 'wormbots/world'

describe World do
  let(:world) { World.new }

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

    it "returns coordinates of worm" do
      world.tick.should have(4).items
    end

    it "returns valid integer points of worm" do
      world.tick.first[0].should be_an_instance_of Fixnum
    end

    it "lets the worms live" do
      worm = world.instance_variable_get("@worms").first
      worm.should_receive(:live).and_return([])
      world.tick
    end

    it "returns coordinates for multiple worms" do
      world.spawn_worm
      world.spawn_worm
      world.tick.should have(12).items
    end
  end
  
  describe "#starting_direction" do
    it "returns a valid starting direction" do
      World::DIRECTIONS.should include(world.send(:starting_direction))
    end
  end

  describe ".restricted_directions" do
    it "returns up restriction" do
      World.restricted_directions([500, 0]).should == [:up]
    end

    it "returns left restriction" do
      World.restricted_directions([0, 475]).should == [:left]
    end

    it "returns right restriction" do
      World.restricted_directions([636, 475]).should == [:right]
    end

    it "returns down restriction" do
      World.restricted_directions([635, 476]).should == [:down]
    end

    it "returns up and left restrictions" do
      World.restricted_directions([0, 0]).should == [:left, :up]
    end

    it "returns up and right restrictions" do
      World.restricted_directions([636, 0]).should == [:right, :up]
    end

    it "returns down and right restrictions" do
      World.restricted_directions([636,476]).should == [:right, :down]
    end
  end

end
