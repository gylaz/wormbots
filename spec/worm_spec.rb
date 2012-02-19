require_relative '../worm'

describe Worm do
  let(:worm) { Worm.new([100, 200], :up) }

  subject { worm }
  its(:points) { should have(4).items }
  its(:direction) { should == :up }

  it "has a valid direction" do
    [:up, :down, :left, :right].should include(subject.direction)
  end

  describe "#possible_directions" do
    context "when moving down" do
      before { subject.direction = :down }

      it "can only go left, right or down" do
        subject.possible_directions.should == [:down, :left, :right]
      end

      it "can only go left or right when at the bottom" do
        subject.points[0] = [50, World::MAX_Y]
        subject.possible_directions.should == [:left, :right]
      end

      it "can only go left when at the bottom and right edge" do
        subject.points[0] = [World::MAX_X, World::MAX_Y]
        subject.possible_directions.should == [:left]
      end
    end

    context "when moving up" do
      before { subject.direction = :up }

      it "can only go left, right or up" do
        subject.possible_directions.should == [:up, :left, :right]
      end

      it "can only go right when at the top and left edge" do
        subject.points[0] = [0, 0]
        subject.possible_directions.should == [:right]
      end
    end

    context "when moving right" do
      before { subject.direction = :right }

      it "can only go up, down or right" do
        subject.possible_directions.should == [:up, :down, :right]
      end

      it "can go up or down when at the right edge" do
        subject.points[0] = [World::MAX_X, 20]
        subject.possible_directions.should == [:up, :down]
      end
    end

    context "when moving left" do
      before { subject.direction = :left }

      it "can only go up, down or left" do
        subject.possible_directions.should == [:up, :down, :left]
      end

      it "can only go up or left when at the bottom" do
        subject.points[0] = [50, World::MAX_Y]
        subject.possible_directions.should == [:up, :left]
      end

      it "can only go up when at the bottom and left edge" do
        subject.points[0] = [0, World::MAX_Y]
        subject.possible_directions.should == [:up]
      end
    end
  end
  
  describe "#live" do
    it "moves" do
      subject.should_receive(:move)
      subject.live
    end

    it "gets older" do
      expect { subject.live }.to change{ subject.age }.by(1)
    end

    it "grows every 10 days" do
     expect { 10.times { subject.live } }.to change{subject.points.size}.by(1)
    end

    it "returns the points" do
      subject.live.should == subject.points
    end
  end

  describe "#move" do
    it "remains the same size" do
      subject.move
      subject.should have(4).points
    end

    context "when moving up" do
      it "moves left when at the top right corner" do
        worm = Worm.new([World::MAX_X,0], :up)
        worm.should_receive(:move_left)
        worm.move
      end

      it "moves right when at the top left corner" do
        worm = Worm.new([0,0], :up)
        worm.should_receive(:move_right)
        worm.move
      end
    end

    context "when moving down" do
      it "moves left when at the bottom right corner" do
        worm = Worm.new([World::MAX_X,World::MAX_Y], :down)
        worm.should_receive(:move_left)
        worm.move
      end

      it "moves right when at the bottom left corner" do
        worm = Worm.new([0,World::MAX_Y], :down)
        worm.should_receive(:move_right)
        worm.move
      end
    end

    context "when moving left" do
      it "moves left when at the top left corner" do
        worm = Worm.new([0, 0], :left)
        worm.should_receive(:move_down)
        worm.move
      end

      it "moves right when at the bottom left corner" do
        worm = Worm.new([0,World::MAX_Y], :left)
        worm.should_receive(:move_up)
        worm.move
      end
    end

    context "when moving right" do
      it "moves left when at the bottom right corner" do
        worm = Worm.new([World::MAX_X,World::MAX_Y], :right)
        worm.should_receive(:move_up)
        worm.move
      end

      it "moves right when at the top right corner" do
        worm = Worm.new([World::MAX_X,0], :right)
        worm.should_receive(:move_down)
        worm.move
      end
    end
  end

  describe "#move_up" do
    let(:worm) { Worm.new([100,200], :right) }
    before {
      worm.direction = :up
      worm.move_up
    }

    it "has the right amount of points" do
      worm.should have(4).points
    end

    it "moves the first point up the y axis" do
      worm.head.should ==  [100, 199]
    end

    it "moves the second point where the first was" do
      worm.points[1].should == [100, 200]
    end
  end

  describe "#move_down" do
    let(:worm) { Worm.new([100,200], :right) }
    before {
      worm.direction = :down
      worm.move_down
    }

    it "moves the first point down the y axis" do
      worm.head.should ==  [100, 201]
    end

    it "moves the second point where the first was" do
      worm.points[1].should == [100, 200]
    end
  end

  describe "#move_left" do
    let(:worm) { Worm.new([100,200], :down) }
    before {
      worm.direction = :left
      worm.move_left
    }

    it "has the right amount of points" do
      worm.should have(4).points
    end

    it "moves the first point left on the x axis" do
      worm.head.should ==  [99, 200]
    end

    it "moves the second point where the first was" do
      worm.points[1].should == [100, 200]
    end
  end

  describe "#move_right" do
    let(:worm) { Worm.new([100,200], :up) }
    before {
      worm.direction = :right
      worm.move_right
    }

    it "has the right amount of points" do
      worm.should have(4).points
    end

    it "moves the first point left on the x axis" do
      worm.head.should ==  [101, 200]
    end

    it "moves the second point where the first was" do
      worm.points[1].should == [100, 200]
    end
  end

  describe "#grow" do
    it "gets another coordinate point" do
      expect{ subject.grow }.to change{ subject.points.size }.by(1)
    end

    it "append appropriate coordinate point" do
      subject.grow
      subject.points.last.should == [100, 204]
    end
  end

  describe "#append_point" do
    it "appends correctly for up direction" do
      Worm.new([100, 200], :up).append_point.should == [100, 204]
    end

    it "appends correctly for down direction" do
      Worm.new([100, 200], :down).append_point.should == [100, 196]
    end

    it "appends correctly for left direction" do
      Worm.new([100, 200], :left).append_point.should == [104, 200]
    end

    it "appends correctly for right direction" do
      Worm.new([100, 200], :right).append_point.should == [96, 200]
    end
  end

  describe "#prepend_point" do
    it "prepends when moving up" do
      subject.direction = :up
      subject.prepend_point.should == [100,199]
    end

    it "prepends when moving down" do
      subject.direction = :down
      subject.prepend_point.should == [100,201]
    end

    it "prepends when moving right" do
      subject.direction = :right
      subject.prepend_point.should == [101,200]
    end

    it "prepends when moving left" do
      subject.direction = :left
      subject.prepend_point.should == [99,200]
    end
  end
end
