require_relative '../test'

unless defined?(Ohm::UniqueIndexViolation)
  module Ohm
    class UniqueIndexViolation < Exception
    end
  end
end

class RouterTest < MiniTest::Test
  class TestHandler
    def login(_message)
      RPC::Message.from(code: RPC::Code::OK)
    end
  end

  class NonMessageReturnHandler
    def login(_msg)
      23321
    end
  end

  class TestAuthHandler
    def login(_msg)
    end

    def authorize_login(_msg)
      false
    end

    def unique_violation(_msg)
      raise Ohm::UniqueIndexViolation.new
    end
  end

  def test_invalid_schema
    logger = MiniTest::Mock.new
    logger.expect(:warn, nil, ['Target auth/login received invalid parameters. Message: id: id target: auth/login, code: 0 params: {:invalid=>10} source: :'])

    router = new_router(TestHandler.new, logger)
    message = RPC::Message.new('id', 'auth/login', nil, {invalid: 10}, RPC::Code::OK, nil)

    res = router.dispatch(message)
    assert(res.is_a?(RPC::Message))
    assert_equal(RPC::Code::INVALID_SCHEMA, res.code)
    assert_equal({email: ["is missing"]}, res[:violations])

    logger.verify
  end

  def test_unknown_target
    logger = MiniTest::Mock.new
    logger.expect(:warn, nil, ['Target auth/logout not found. Message: id: id target: auth/logout, code: 0 params: {} source: :'])

    router = new_router(TestHandler.new, logger)
    message = RPC::Message.new('id', 'auth/logout', nil, {email: 'hello@example.com'}, RPC::Code::OK, nil)

    res = router.dispatch(message)
    assert(res.is_a?(RPC::Message))
    assert_equal(RPC::Code::UNKNOWN_TARGET, res.code)

    logger.verify
  end

  def test_access_denied
    logger = MiniTest::Mock.new
    logger.expect(:warn, nil, ['Acces denied. Message: id: id target: auth/login, code: 0 params: {} source: :'])

    router = new_router(TestAuthHandler.new, logger)

    message = RPC::Message.new('id', 'auth/login', nil, {email: 'hello@example.com'}, RPC::Code::OK, nil)

    res = router.dispatch(message)
    assert(res.is_a?(RPC::Message))
    assert_equal(RPC::Code::ACCESS_DENIED, res.code)

    logger.verify
  end

  def test_unique_violation
    logger = MiniTest::Mock.new
    logger.expect(:info, nil, ['Ohm::UniqueIndexViolation. Message: id: id target: auth/unique_violation, code: 0 params: {} source: :'])

    router = new_router(TestAuthHandler.new, logger)

    message = RPC::Message.new('id', 'auth/unique_violation', nil, {email: 'hello@example.com'}, RPC::Code::OK, nil)

    res = router.dispatch(message)
    assert(res.is_a?(RPC::Message))
    assert_equal(RPC::Code::UNIQUE_VIOLATION, res.code)

    logger.verify
  end

  def test_happy_path
    router = new_router(TestHandler.new)
    message = RPC::Message.new('id', 'auth/login', nil, {email: 'hello@example.com'}, RPC::Code::OK, nil)

    res = router.dispatch(message)
    assert(res.is_a?(RPC::Message))
    assert_equal(RPC::Code::OK, res.code)
  end

  def test_non_message_return
    router = new_router(NonMessageReturnHandler.new)
    message = RPC::Message.new('id', 'auth/login', nil, {email: 'hello@example.com'}, RPC::Code::OK, nil)

    res = router.dispatch(message)
    assert_nil(res)
  end

  class TestLoginSchema < Dry::Validation::Contract
    params do
      required(:email).filled
    end
  end

  private
  def new_router(handler, logger = nil)
    map = {
      auth: {handler: handler, schema: {
        login: TestLoginSchema.new,
        unique_violation: TestLoginSchema.new
      }}
    }
    logger = logger ? logger : NULL_LOGGER

    RPC::Router.new(map, logger)
  end
end
