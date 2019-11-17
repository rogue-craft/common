require_relative 'test'

class ListenerRegistrationTest < MiniTest::Test

  def test_common_listeners
    container = mock
    container.expects(:resolve).with(:serializer).returns(serializer = mock)
    container.expects(:resolve).with(:async_store).returns(async_store = mock)
    container.expects(:resolve).with(:router).returns(router = mock)

    RPC::ConnectionListener.expects(:new).with(serializer, async_store, router).returns(listener = mock)

    publisher = mock
    publisher.expects(:register_event).with(:receive_data)
    publisher.expects(:subscribe).with(listener)

    RogueCraftCommon.register_common_listeners(publisher, container)
  end
end
