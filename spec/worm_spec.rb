require_relative '../worm'

describe Worm do
  its(:size) { should == 4 }
  its(:coords) { should have(4).items }


  it "has a valid direction" do
    [:up, :down, :left, :right].should include(subject.direction)
  end

  context "when moving down" do
    before { subject.direction = :down }

    it "can only go left, right or down" do
      subject.possible_directions.should == [:down, :left, :right]
    end
  end

  context "when moving up" do
    before { subject.direction = :up }

    it "can only go left, right or up" do
      subject.possible_directions.should == [:up, :left, :right]
    end
  end

  context "when moving right" do
    before { subject.direction = :right }

    it "can only go up, down or right" do
      subject.possible_directions.should == [:up, :down, :right]
    end
  end

  context "when moving left" do
    before { subject.direction = :left }

    it "can only go up, down or left" do
      subject.possible_directions.should == [:up, :down, :left]
    end
  end
  
  describe "#live" do
    it "moves"
    it "gets older"
    it "grows every 10 days"
    context "when reaches the next 10 days" do
    end
  end

  describe "#move" do
  end

  describe "#grow" do
    it "increases in size" do
      expect{ subject.grow }.to change{ subject.size }.by(1)
    end

    it "gets another coordinate point" do
      expect{ subject.grow }.to change{ subject.coords.size }.by(1)
    end
  end
end