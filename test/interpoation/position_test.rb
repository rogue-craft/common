require_relative '../test'

class PositionTest < MiniTest::Test

  def test_all
    expected = [
      Interpolation::Direction::NORTH,
      Interpolation::Direction::EAST,
      Interpolation::Direction::SOUTH,
      Interpolation::Direction::WEST,
      Interpolation::Direction::NORTH_EAST,
      Interpolation::Direction::SOUTH_EAST,
      Interpolation::Direction::SOUTH_WEST,
      Interpolation::Direction::NORTH_WEST
    ].sort

    actual = Interpolation::Direction.all.sort

    assert_equal(expected, actual)
  end
end
