module Interpolation

  def self.position(x, y, speed, direction, since)
    distance = (Time.now_ms - since) * speed

    unless 0 == direction & Interpolation::Direction::NORTH
      y = (y + distance)
      hitbox_y = y.floor
    end

    unless 0 == direction & Interpolation::Direction::SOUTH
      y = (y - distance)
      hitbox_y = y.ceil
    end

    unless 0 == direction & Interpolation::Direction::EAST
      x = (x + distance)
      hitbox_x = x.floor
    end

    unless 0 == direction & Interpolation::Direction::WEST
      x = (x - distance)
      hitbox_x = x.ceil
    end

    [x, y, hitbox_x, hitbox_y]
  end
end
