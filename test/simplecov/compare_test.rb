# frozen_string_literal: true

require "minitest/autorun"

describe Simplecov::Compare do
  it "has a version number" do
    assert Simplecov::Compare::VERSION != nil
  end
end
