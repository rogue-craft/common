$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require_relative "../lib/rogue-craft-common"

require 'logger'
require "minitest/autorun"

NULL_LOGGER = Logger.new(IO::NULL)

