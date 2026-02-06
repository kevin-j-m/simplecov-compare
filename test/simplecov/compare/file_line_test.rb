# frozen_string_literal: true

require "test_helper"

module Simplecov
  module Compare
    describe FileLine do
      describe "#irrelevant?" do
        it "is true when the covered count is nil" do
          line = FileLine.new(line_number: 3, covered_count: nil)

          assert_equal true, line.irrelevant?
        end

        it "is false when the covered count is a number" do
          line = FileLine.new(line_number: 3, covered_count: 1)

          assert_equal false, line.irrelevant?
        end
      end

      describe "#relevant?" do
        it "is false when the covered count is nil" do
          line = FileLine.new(line_number: 3, covered_count: nil)

          assert_equal false, line.relevant?
        end

        it "is true when the covered count is a number" do
          line = FileLine.new(line_number: 3, covered_count: 1)

          assert_equal true, line.relevant?
        end
      end

      describe "#missed?" do
        it "is true when a relevant line has a covered count of zero" do
          line = FileLine.new(line_number: 3, covered_count: 0)

          assert_equal true, line.missed?
        end

        it "is false when the line is irrelevant" do
          line = FileLine.new(line_number: 3, covered_count: nil)

          assert_equal false, line.missed?
        end

        it "is false for a relevant line with a covered count" do
          line = FileLine.new(line_number: 3, covered_count: 1)

          assert_equal false, line.missed?
        end
      end

      describe "#covered?" do
        it "is true for a relevant line with a covered count" do
          line = FileLine.new(line_number: 3, covered_count: 1)

          assert_equal true, line.covered?
        end

        it "is false when a relevant line has a covered count of zero" do
          line = FileLine.new(line_number: 3, covered_count: 0)

          assert_equal false, line.covered?
        end

        it "is false when the line is irrelevant" do
          line = FileLine.new(line_number: 3, covered_count: nil)

          assert_equal false, line.covered?
        end
      end
    end
  end
end
