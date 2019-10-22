require_relative '../test'

class MessageTest < MiniTest::Test

  def test_code
    msg = RPC::Message.from(code: RPC::Code::INTERNAL_ERROR)

    assert(false == msg.code?(RPC::Code::OK))
    assert(true == msg.code?(RPC::Code::INTERNAL_ERROR))
  end
end
