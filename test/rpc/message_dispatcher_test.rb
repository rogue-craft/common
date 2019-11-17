require_relative '../test'

class MessageDispatcherTest < MiniTest::Test

  def test_default_connection_with_response
    msg = RPC::Message.from

    serializer = mock
    serializer.expects(:serialize_msg).with(msg).returns('serialized')

    callback = proc {}

    async_store = mock
    async_store.expects(:add).with(msg.id, callback, is_a(Time))

    default_connection = mock
    default_connection.expects(:send_data).with('serialized')

    dispatcher = RPC::MessageDispatcher.new(serializer, async_store, default_connection)

    dispatcher.dispatch(msg, nil, &callback)
  end

  def test_connection_without_response
    msg = RPC::Message.from

    serializer = mock
    serializer.expects(:serialize_msg).with(msg).returns('serialized')

    connection = mock
    connection.expects(:send_data).with('serialized')

    dispatcher = RPC::MessageDispatcher.new(serializer, nil, nil)

    dispatcher.dispatch(msg, connection)
  end
end
