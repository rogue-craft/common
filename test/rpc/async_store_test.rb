require_relative '../test'

class AsyncStoreTest < MiniTest::Test

  def test_happy_path
    logger = mock

    store = RPC::AsyncStore.new(1, logger)
    assert(false == store.has?(:id_1))

    val = 1
    store.add(:id_1, proc { |msg| val += msg[:val]}, 1)
    assert(store.has?(:id_1))

    msg = RPC::Message.from(params: {val: 10})
    store.call(:id_1, msg)

    assert_equal(11, val)
    assert(false == store.has?(:id_1))
  end

  def test_exception
    msg = RPC::Message.from

    logger = mock
    logger.expects(:warn).with("AsyncStore: error in callback: Exception Parent: id_1, Message: id: #{msg.id} target: , code: 0 params: {} source: :")

    store = RPC::AsyncStore.new(1, logger)
    assert(false == store.has?(:id_1))

    store.add(:id_1, proc { raise Exception.new }, 1)
    assert(store.has?(:id_1))

    store.call(:id_1, msg)
    assert(false == store.has?(:id_1))
  end

  def test_clear
    logger = mock

    store = RPC::AsyncStore.new(2, logger)
    assert(false == store.has?(:id))

    store.add(:id, nil, 10)
    assert(store.has?(:id))

    store.clear(11)
    assert(store.has?(:id))

    store.clear(12)
    assert(false == store.has?(:id))
  end
end
