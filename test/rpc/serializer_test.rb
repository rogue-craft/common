require_relative '../test'

class SerializerTest < MiniTest::Test
  def test_serialization
    serializer = RPC::Serializer.new(NULL_LOGGER)

    serialized = serializer.serialize(RPC::Message.new('id', 'target', nil, {hello: [10]}, RPC::Code::OK, :source))
    assert(serialized.is_a?(String))

    restored = serializer.unserialize(serialized, nil)
    assert(restored.is_a?(RPC::Message))

    assert(
      'id' == restored.id &&
      'target' == restored.target &&
      nil == restored.parent &&
      {hello: [10]} == restored.params &&
      RPC::Code::OK == restored.code,
      :source == restored.source
    )
  end

  def test_invalid_message
    logger = MiniTest::Mock.new
    logger.expect(:warn, nil, ['Invalid message received: {:id=>"id", :target=>nil, :parent=>nil, :params=>{:hello=>"Asd"}, :code=>0}'])

    serializer = RPC::Serializer.new(logger)

    serialized = serializer.serialize(RPC::Message.new('id', nil, nil, {hello: 'Asd'}, RPC::Code::OK, nil))

    restored = serializer.unserialize(serialized, nil)
    assert(restored.nil?)

    logger.verify
  end
end
