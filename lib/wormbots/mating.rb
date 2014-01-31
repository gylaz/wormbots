class Mating
  def initialize(worm, worms)
    @worm = worm
    @other_worms = worms - [worm]
  end

  def intersection_coordinates
    if @worm.fertile?
      intersection_with_another_fertile_worm
    end
  end

  private

  def intersection_with_another_fertile_worm
    fertile_worms.each do |fertile_worm|
      if (intersection = intersection(fertile_worm))
        return intersection
      end
    end

    nil
  end

  def fertile_worms
    @other_worms.select { |worm| worm.fertile? }
  end

  def intersection(other_worm)
    (@worm.coordinates & other_worm.coordinates).first
  end
end
