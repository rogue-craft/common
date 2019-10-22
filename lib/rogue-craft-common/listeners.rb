def RogueCraftCommon.register_common_listeners(publisher, container)
  publisher.register_event(:receive_data)

  publisher.subscribe(RPC::ConnectionListener.new(
    container.resolve(:serializer),
    container.resolve(:async_store),
    container.resolve(:router)
  ))
end
