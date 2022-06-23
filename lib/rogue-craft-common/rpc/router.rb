class RPC::Router
  def initialize(route_map, logger)
    @route_map = route_map
    @logger = logger
  end

  def dispatch(message)
    target = message.target

    ns_name, action = target.split('/').map(&:to_sym)
    namespace = @route_map.fetch(ns_name, {})
    handler = namespace.fetch(:handler, nil)
    schema = namespace.dig(:schema, action)

    unless handler && schema
      return unknow_target(message)
    end

    validation = schema.call(message.params)

    unless validation.success?
      return invalid_schema(message, validation.errors)
    end

    response = execute(handler, action, message)

    if response.is_a?(RPC::Message)
      return response
    end
  end

  private
  def execute(handler, action, message)
    authorizer = 'authorize_' + action.to_s

    if handler.respond_to?(authorizer)
      unless handler.send(authorizer, message)
        return acces_denied(message)
      end
    end

    begin
      @logger.debug("Calling Handler: #{handler}::#{action} Message: #{message}")

      call_handler(handler, action, message)
    rescue Exception => e
      if defined?(Ohm) && e.is_a?(Ohm::UniqueIndexViolation)
        return unique_violation(message, e)
      end
      raise e
    end
  end

  def call_handler(handler, action, message)
    handler.send(action, message)
  end

  def unknow_target(msg)
    @logger.warn("Target #{msg.target} not found. Message: #{msg}")

    return RPC::Message.from(parent: msg.id, code: RPC::Code::UNKNOWN_TARGET)
  end

  def invalid_schema(msg, violations)
    @logger.warn("Target #{msg.target} received invalid parameters. Violations: #{violations.to_h} Message: #{msg}")

    return RPC::Message.from(parent: msg.id, code: RPC::Code::INVALID_SCHEMA, params: {violations: violations.to_h})
  end

  def unique_violation(msg, err)
    @logger.info("#{err}. Message: #{msg}")
    field = err.message.gsub('UniqueIndexViolation: ', '').to_sym

    return RPC::Message.from(parent: msg.id, code: RPC::Code::UNIQUE_VIOLATION, params: {violations: {field => ['already exists']}})
  end

  def acces_denied(msg)
    @logger.warn("Acces denied. Message: #{msg}")

    return RPC::Message.from(parent: msg.id, code: RPC::Code::ACCESS_DENIED)
  end
end
