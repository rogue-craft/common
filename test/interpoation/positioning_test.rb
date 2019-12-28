require_relative '../test'

class PositioningTest < MiniTest::Test

  def test_north_east
    run_test(110, 1, Interpolation::Direction::NORTH_EAST, 10, 10)
  end

  def test_south_west
    run_test(102, 1, Interpolation::Direction::SOUTH_WEST, -2, -2)
  end

  def test_partial_movement
    run_test(105, 0.1, Interpolation::Direction::NORTH_WEST, 0, 0)
  end

  def test_reached_with_partial_movement
    run_test(112, 0.1, Interpolation::Direction::WEST, -1, 0)
  end

  private
  def run_test(current_time, speed, direction, expected_x, expected_y)
    Time.expects(:now_ms).returns(current_time)

    x, y = Interpolation.position(
      0, 0, speed, direction, 100
    )

    assert_equal(expected_x, x)
    assert_equal(expected_y, y)
  end
end
