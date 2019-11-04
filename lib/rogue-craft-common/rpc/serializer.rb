class RPC::Serializer
  def initialize(logger)
    @logger = logger

    MessagePack::DefaultFactory.register_type(0x00, Symbol)
  end

  def serialize(value)
    value.to_msgpack
  end

  def unserialize(raw)
    MessagePack.unpack(raw).to_h
  end

  def serialize_msg(msg)
    {
      id: msg.id,
      target: msg.target,
      parent: msg.parent,
      params: msg.params,
      code: msg.code
    }.to_msgpack
  end

  def unserialize_msg(raw, source)
    begin
      values = MessagePack.unpack(raw).to_h
    rescue Exception => e
      @logger.warn("Unable to unserialize message #{raw} Err: #{e.message}")
      return nil
    end

    msg = RPC::Message.new(
      values.fetch(:id, nil),
      values.fetch(:target, nil),
      values.fetch(:parent, nil),
      values.fetch(:params, {}),
      values.fetch(:code, 0),
      source
    ).freeze

    unless valid_message?(msg)
      @logger.warn("Invalid message received: #{values.to_s}")
      return nil
    end

    msg
  end

  private
  def valid_message?(msg)
    msg.id.is_a?(String) &&
      (msg.target.is_a?(String) ^ msg.parent.is_a?(String))
  end
end
