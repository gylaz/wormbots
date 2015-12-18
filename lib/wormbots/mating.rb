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
    fertile_worms_in_proximity.each do |fertile_worm|
      if (intersection = intersection(fertile_worm))
        return intersection
      end
    end

    nil
  end

  def fertile_worms_in_proximity
    fertile_worms.reject do |fertile_worm|
      fertile_min_x, fertile_max_x = fertile_worm.coordinates.minmax_by(&:x)
      fertile_min_y, fertile_max_y = fertile_worm.coordinates.minmax_by(&:y)
      worm_min_x, worm_max_x = @worm.coordinates.minmax_by(&:x)
      worm_min_y, worm_max_y = @worm.coordinates.minmax_by(&:y)

      fertile_max_x.x < worm_min_x.x || fertile_min_x.x > worm_max_x.x ||
        fertile_max_y.y < worm_min_y.y || fertile_min_y.y > worm_max_y.y
    end
  end

  def fertile_worms
    @other_worms.select(&:fertile?)
  end

  def intersection(other_worm)
    (@worm.coordinates & other_worm.coordinates).first
  end
end
