class RPC::AsyncStore

  def initialize(timeout, logger)
    @timeout = timeout
    @logger = logger
    @pending = {}
  end

  def add(id, block, created_at)
    @pending[id] = OpenStruct.new(id: id, block: block, created_at: created_at)
  end

  def has?(id)
    @pending.key?(id)
  end

  def call(id, msg)
    @pending[id].block.call(msg)
  rescue Exception => e
    @logger.warn("AsyncStore: error in callback: #{e.message} Parent: #{id}, Message: #{msg.to_s}")
  ensure
    @pending.delete(id)
  end

  def clear(time)
    @pending.reject! { |msg| msg.created_at + @timeout > time}
  end
end
