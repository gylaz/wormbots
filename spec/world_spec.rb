require 'wormbots'

describe World do
  let(:world) { World.new }

  describe "#fiber" do
    it "returns a fiber" do
      world.fiber.should be_an_instance_of Fiber
    end
  end

  describe "#spawn_worm" do
    it "adds a worm isntance to @worms" do
      expect { world.spawn_worm }.to change { world.worms.size }.by(1)
    end

    it "adds a worm isntance to @worms with specific coordinates" do
      world.spawn_worm([5, 5])
      world.worms.last.points.first.should == Point.new(5, 5)
    end
  end

  describe "#tick" do
    before do
      world.spawn_worm
      sleep 0.1
    end

    it "updates last_update" do
      expect { world.tick }.to change {
        world.instance_variable_get("@last_update") }
    end

    it "lets the worms live" do
      worm = world.instance_variable_get("@worms").first
      worm.should_receive(:live).with(1)
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
end
