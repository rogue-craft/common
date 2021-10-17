require_relative '../test'

class ClockTest < MiniTest::Test
  def test_override
    clock = Interpolation::Clock.new(Time.new)

    assert_raises(RuntimeError) do
      clock.base = Time.new
    end
  end

  def test_elapsed_time
    base = Time.new - 5
    clock = Interpolation::Clock.new(base)

    sleep(2)

    assert_in_delta(clock.now - ((base.to_f * 1000) + 2000), 2, 0.2)
  end
end
