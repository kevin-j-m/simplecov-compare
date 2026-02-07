# frozen_string_literal: true

require "test_helper"

module Simplecov
  module Compare
    module Reporter
      describe SimpleReporter do
        describe "#report" do
          it "outputs the provided information to std-out" do
            assert_output("here are all the differences\n") { SimpleReporter.new.report("here are all the differences") }
          end
        end
      end
    end
  end
end
