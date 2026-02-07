# frozen_string_literal: true

require "minitest/autorun"
require "mocktail"
require_relative "../lib/simplecov/compare"

class Minitest::Test
  include Mocktail::DSL

  def teardown
    super
    Mocktail.reset
  end
end
