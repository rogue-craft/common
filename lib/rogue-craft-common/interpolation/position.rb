module Interpolation

  def self.position(x, y, speed, direction, since)
    distance = (Time.now_ms - since) * speed

    y = (y + distance).floor unless 0 == direction & Interpolation::Direction::NORTH
    y = (y - distance).ceil unless 0 == direction & Interpolation::Direction::SOUTH
    x = (x + distance).floor unless 0 == direction & Interpolation::Direction::EAST
    x = (x - distance).ceil unless 0 == direction & Interpolation::Direction::WEST

    [x, y]
  end
end
