require 'wormbots'

describe Worm do
  let(:initial_x) { 100 }
  let(:initial_y) { 200 }
  let(:worm) { Worm.new([initial_x, initial_y], :up) }

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
        subject.points[0] = Point.new(50, World::MAX_Y)
        subject.possible_directions.should == [:left, :right]
      end

      it "can only go left when at the bottom and right edge" do
        subject.points[0] = Point.new(World::MAX_X, World::MAX_Y)
        subject.possible_directions.should == [:left]
      end
    end

    context "when moving up" do
      before { subject.direction = :up }

      it "can only go left, right or up" do
        subject.possible_directions.should == [:up, :left, :right]
      end

      it "can only go right when at the top and left edge" do
        subject.points[0] = Point.new(0, 0)
        subject.possible_directions.should == [:right]
      end
    end

    context "when moving right" do
      before { subject.direction = :right }

      it "can only go up, down or right" do
        subject.possible_directions.should == [:up, :down, :right]
      end

      it "can go up or down when at the right edge" do
        subject.points[0] = Point.new(World::MAX_X, 20)
        subject.possible_directions.should == [:up, :down]
      end
    end

    context "when moving left" do
      before { subject.direction = :left }

      it "can only go up, down or left" do
        subject.possible_directions.should == [:up, :down, :left]
      end

      it "can only go up or left when at the bottom" do
        subject.points[0] = Point.new(50, World::MAX_Y)
        subject.possible_directions.should == [:up, :left]
      end

      it "can only go up when at the bottom and left edge" do
        subject.points[0] = Point.new(0, World::MAX_Y)
        subject.possible_directions.should == [:up]
      end
    end
  end
  
  describe "#live" do
    it "does not do anything with zero days" do
      subject.should_not_receive(:move)
      subject.should_not_receive(:grow)
      expect { subject.live(0) }.not_to change { subject.age }
    end

    it "moves" do
      subject.should_receive(:move)
      subject.live(1)
    end

    it "moves once for each day" do
      subject.should_receive(:move).exactly(3).times
      subject.live(3)
    end

    it "gets older" do
      expect { subject.live(5) }.to change{ subject.age }.by(5)
    end

    it "grows every 10 days" do
     expect { subject.live(10) }.to change{subject.points.size}.by(1)
    end

    context "after 500 days" do
      before { subject.live(500) }

      its(:age) { should == 500 }
      its(:points) { should have(40).items }

      it "doesn't have any negative coordinates" do
        subject.points.each do |point|
          point.x.should >= 0
          point.y.should >= 0
        end
      end

      it "doesn't have any out of limit coordinates" do
        subject.points.each do |point|
          point.x.should <= World::MAX_X
          point.y.should <= World::MAX_Y
        end
      end
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
    let(:worm) { Worm.new([initial_x, initial_y], :right) }

    before {
      worm.direction = :up
      worm.move_up
    }

    it "has the right amount of points" do
      worm.should have(4).points
    end

    it "moves the first point up the y axis" do
      worm.head.x.should == initial_x
      worm.head.y.should == initial_y - Worm::UNIT_SIZE
    end

    it "moves the second point where the first was" do
      worm.points[1].x.should == initial_x
      worm.points[1].y.should == initial_y
    end
  end

  describe "#move_down" do
    let(:worm) { Worm.new([initial_x, initial_y], :right) }

    before {
      worm.direction = :down
      worm.move_down
    }

    it "moves the first point down the y axis" do
      worm.head.x.should == initial_x
      worm.head.y.should == initial_y + Worm::UNIT_SIZE
    end

    it "moves the second point where the first was" do
      worm.points[1].x.should == initial_x
      worm.points[1].y.should == initial_y
    end
  end

  describe "#move_left" do
    let(:worm) { Worm.new([initial_x, initial_y], :down) }

    before {
      worm.direction = :left
      worm.move_left
    }

    it "has the right amount of points" do
      worm.should have(4).points
    end

    it "moves the first point left on the x axis" do
      worm.head.x.should == initial_x - Worm::UNIT_SIZE
      worm.head.y.should == initial_y
    end

    it "moves the second point where the first was" do
      worm.points[1].x.should == initial_x
      worm.points[1].y.should == initial_y
    end
  end

  describe "#move_right" do
    let(:worm) { Worm.new([initial_x, initial_y], :down) }

    before {
      worm.direction = :right
      worm.move_right
    }

    it "has the right amount of points" do
      worm.should have(4).points
    end

    it "moves the first point left on the x axis" do
      worm.head.x.should == initial_x + Worm::UNIT_SIZE
      worm.head.y.should == initial_y
    end

    it "moves the second point where the first was" do
      worm.points[1].x.should == initial_x
      worm.points[1].y.should == initial_y
    end
  end

  describe "#grow" do
    it "gets another coordinate point" do
      expect{ subject.grow }.to change{ subject.points.size }.by(1)
    end

    it "append appropriate coordinate point" do
      subject.grow
      subject.tail.x.should == initial_x
      subject.tail.y.should == (initial_y + 3) + Worm::UNIT_SIZE
    end
  end

  describe "#append_point" do
    it "increases number of points" do
      worm.append_point
      worm.should have(5).points
    end

    it "appends correctly for up direction" do
      worm = Worm.new([initial_x, initial_y], :up)
      worm.append_point
      worm.tail.x.should == initial_x
      worm.tail.y.should == (initial_y + 3) + Worm::UNIT_SIZE
    end

    it "appends correctly for down direction" do
      worm = Worm.new([initial_x, initial_y], :down)
      worm.append_point
      worm.tail.x.should == initial_x
      worm.tail.y.should == (initial_y - 3) - Worm::UNIT_SIZE
    end

    it "appends correctly for left direction" do
      worm = Worm.new([initial_x, initial_y], :left)
      worm.append_point
      worm.tail.x.should == (initial_x + 3) + Worm::UNIT_SIZE
      worm.tail.y.should == initial_y
    end

    it "appends correctly for right direction" do
      worm = Worm.new([initial_x, initial_y], :right)
      worm.append_point
      worm.tail.x.should == (initial_x - 3) - Worm::UNIT_SIZE
      worm.tail.y.should == initial_y
    end
  end

  describe "#prepend_point" do
    it "adds a new point" do
      subject.prepend_point
      subject.should have(5).points
    end

    it "prepends when moving up" do
      subject.direction = :up
      subject.prepend_point
      worm.head.x.should == initial_x
      worm.head.y.should == initial_y - Worm::UNIT_SIZE
    end

    it "prepends when moving down" do
      subject.direction = :down
      subject.prepend_point
      worm.head.x.should == initial_x
      worm.head.y.should == initial_y + Worm::UNIT_SIZE
    end

    it "prepends when moving right" do
      subject.direction = :right
      subject.prepend_point
      worm.head.x.should == initial_x + Worm::UNIT_SIZE
      worm.head.y.should == initial_y
    end

    it "prepends when moving left" do
      subject.direction = :left
      subject.prepend_point
      worm.head.x.should == initial_x - Worm::UNIT_SIZE
      worm.head.y.should == initial_y
    end
  end
end
