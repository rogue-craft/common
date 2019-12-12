class RPC::ConnectionListener

  def initialize(serializer, async_store, router, logger)
    @serializer = serializer
    @async_store = async_store
    @router = router
    @logger = logger
  end

  def on_receive_data(event)
    conn = event[:connection]

    if msg = @serializer.unserialize_msg(event[:raw], conn)
      if msg.parent
        if @async_store.has?(msg.parent)
          @async_store.call(msg.parent, msg)
        else
          @logger.warn("Parent id not found in asnyc store. Message: #{msg}")
        end
        return
      end

      if response = @router.dispatch(msg)
        conn.send_data(@serializer.serialize_msg(response))
      end
    end
  end
end
