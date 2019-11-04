class RPC::ConnectionListener

  def initialize(serializer, async_store, router)
    @serializer = serializer
    @async_store = async_store
    @router = router
  end

  def on_receive_data(event)
    conn = event[:connection]

    if msg = @serializer.unserialize_msg(event[:raw], conn)
      if msg.parent && @async_store.has?(msg.parent)
        @async_store.call(msg.parent, msg)
        return
      end

      response = @router.dispatch(msg)
      conn.send_data(@serializer.serialize_msg(response))
    end
  end
end
