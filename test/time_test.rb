require_relative 'test'

class TimeTest < MiniTest::Test

  def test_now_ms
    now = mock
    now.expects(:to_f).returns(100.0)

    Time.expects(:now).returns(now)

    assert_equal(100.0 * 1000, Time.now_ms)
  end
end
