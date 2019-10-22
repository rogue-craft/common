class RPC::Handler
  def initialize(dispatcher)
    @dispatcher = dispatcher
  end

  private
  def send_msg(conn: nil, target: nil, params: {}, code: RPC::Code::OK, parent: nil, &callback)
    msg = new_msg(target: target, params: params, code: code, parent: parent)

    @dispatcher.dispatch(msg, conn, &callback)
  end

  def new_msg(target: nil, params: {}, code: RPC::Code::OK, parent: nil)
    parent = parent.id if parent

    RPC::Message.from(target: target, params: params, code: code, parent: parent)
  end
end

if defined?(Dependency)
  class RPC::InjectedHandler < RPC::Handler
    include Dependency[:message_dispatcher]

    def initialize(args)
      super(args[:message_dispatcher])
    end
  end
end
