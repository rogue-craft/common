require_relative '../test'

class ConnectionListenerReceiveTest < MiniTest::Test

  def test_invalid_message
    event = new_event

    serializer = MiniTest::Mock.new
    serializer.expect(:unserialize_msg, nil, [event[:raw], event[:connection]])

    listener = RPC::ConnectionListener.new(serializer, nil, nil, nil)
    listener.on_receive_data(event)

    serializer.verify
  end

  def test_async_response
    event = new_event
    msg = RPC::Message.from(parent: 'parent_id')

    serializer = MiniTest::Mock.new
    serializer.expect(:unserialize_msg, msg, [event[:raw], event[:connection]])

    store = MiniTest::Mock.new
    store.expect(:has?, true, [msg.parent])
    store.expect(:call, nil, [msg.parent, msg])

    listener = RPC::ConnectionListener.new(serializer, store, nil, nil)
    listener.on_receive_data(event)

    store.verify
    serializer.verify
  end

  def test_async_response_parent_not_found
    event = new_event
    msg = RPC::Message.from(parent: 'parent_id')

    serializer = MiniTest::Mock.new
    serializer.expect(:unserialize_msg, msg, [event[:raw], event[:connection]])

    store = MiniTest::Mock.new
    store.expect(:has?, false, [msg.parent])

    logger = MiniTest::Mock.new
    logger.expect(:warn, nil, ["Parent id not found in asnyc store. Message: id: #{msg.id} target: , code: 0 params: {} source: :"])

    listener = RPC::ConnectionListener.new(serializer, store, nil, logger)
    listener.on_receive_data(event)

    store.verify
    serializer.verify
    logger.verify
  end

  def test_new_incoming_message
    response = RPC::Message.from
    serialized_response = 'serialized'

    connection = MiniTest::Mock.new
    connection.expect(:send_data, nil, [serialized_response])

    event = new_event(connection: connection)
    msg = RPC::Message.from(params: {blah: false})

    serializer = MiniTest::Mock.new
    serializer.expect(:unserialize_msg, msg, [event[:raw], connection])
    serializer.expect(:serialize_msg, serialized_response, [response])

    router = MiniTest::Mock.new
    router.expect(:dispatch, response, [msg])

    listener = RPC::ConnectionListener.new(serializer, nil, router, nil)
    listener.on_receive_data(event)

    router.verify
    connection.verify
    serializer.verify
  end

  def test_no_response
    connection = MiniTest::Mock.new

    event = new_event(connection: connection)
    msg = RPC::Message.from(params: {blah: false})

    serializer = MiniTest::Mock.new
    serializer.expect(:unserialize_msg, msg, [event[:raw], connection])

    router = MiniTest::Mock.new
    router.expect(:dispatch, nil, [msg])

    listener = RPC::ConnectionListener.new(serializer, nil, router, nil)
    listener.on_receive_data(event)

    router.verify
    connection.verify
    serializer.verify
  end

  private
  def new_event(connection: :connection_instance)
    {raw: 'binary data', connection: connection}
  end
end
