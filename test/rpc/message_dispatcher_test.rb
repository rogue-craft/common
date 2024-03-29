require_relative '../test'

class MessageDispatcherTest < MiniTest::Test

  def test_default_connection_with_response
    msg = RPC::Message.from

    serializer = mock
    serializer.expects(:serialize_msg).with(msg).returns('serialized')

    callback = proc {}

    Time.expects(:now).returns(10.1)

    async_store = mock
    async_store.expects(:add).with(msg.id, callback, 10100.0)

    default_connection = mock
    default_connection.expects(:send_data).with('serialized')

    dispatcher = RPC::MessageDispatcher.new(serializer, async_store, default_connection, mock_logger)

    dispatcher.dispatch(msg, nil, &callback)
  end

  def test_connection_without_response
    msg = RPC::Message.from

    serializer = mock
    serializer.expects(:serialize_msg).with(msg).returns('serialized')

    connection = mock
    connection.expects(:send_data).with('serialized')

    dispatcher = RPC::MessageDispatcher.new(serializer, nil, nil, mock_logger)

    dispatcher.dispatch(msg, connection)
  end

  private
  def mock_logger
    logger = mock
    logger.expects(:debug)

    logger
  end
end
