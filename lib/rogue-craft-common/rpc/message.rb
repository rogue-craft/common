class RPC::Message
  attr_reader :id, :target, :parent, :code, :source, :params

  def initialize(id, target, parent, params, code, source)
    @id = id ? id : SecureRandom.uuid
    @target = target
    @parent = parent
    @code = code
    @source = source
    @params = params.to_h

    @params.freeze
  end

  def self.from(target: nil, parent: nil, params: {}, code: RPC::Code::OK, source: nil)
    new(
      SecureRandom.uuid,
      target,
      parent,
      params,
      code,
      source
    )
  end

  def [](key)
    @params[key]
  end

  def fetch(key, default = nil)
    @params.fetch(key, default)
  end

  def code?(code)
    code == @code
  end

  def to_s
    port, ip = source ? Socket.unpack_sockaddr_in(source.get_peername) : [nil, nil]

    "id: #{id} target: #{target}, code: #{code} params: #{logged_params} source: #{ip}:#{port}"
  end

  UNLOGGED_PARAMS = %i[password password_confirmation email]

  private
  def logged_params
    @params.reject { |k, _| UNLOGGED_PARAMS.include?(k) }
  end
end
