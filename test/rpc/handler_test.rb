require_relative '../test'

class HandlerTest < MiniTest::Test
  PARENT = RPC::Message.from.freeze

  class TestHandler < RPC::Handler
    def test_send
      send_msg(code:RPC::Code::ACCESS_DENIED, target: 'target', params: {hello: 10}, parent: PARENT)
    end
  end

  def test_send
    dispatcher = mock
    dispatcher.expects(:dispatch).yields.with do |msg|
      assert(msg.code?(RPC::Code::ACCESS_DENIED))
      assert_equal('target', msg.target)
      assert_equal({hello: 10}, msg.params)
      assert_equal(PARENT.id, msg.parent)
    end

    handler = TestHandler.new(dispatcher)
    handler.test_send
  end
end
