class RPC::MessageDispatcher

  def initialize(serializer, async_store, default_connection, logger)
    @serializer = serializer
    @async_store = async_store
    @default_connection = default_connection
    @logger = logger
  end

  def dispatch(msg, connection, &callback)
    serialized = @serializer.serialize_msg(msg)

    if serialized
      if callback
        @async_store.add(msg.id, callback, Time.now.to_f * 1000)
      end

      @logger.debug("Dispatching message: #{msg}")

      (connection || @default_connection).send_data(serialized)
    end
  end
end
