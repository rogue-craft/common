class RPC::MessageDispatcher

  def initialize(serializer, async_store, default_connection)
    @serializer = serializer
    @async_store = async_store
    @default_connection = default_connection
  end

  def dispatch(msg, connection, &callback)
    serialized = @serializer.serialize_msg(msg)

    if serialized
      if callback
        @async_store.add(msg.id, callback, Time.now.to_f * 1000)
      end

      (connection || @default_connection).send_data(serialized)
    end
  end
end
