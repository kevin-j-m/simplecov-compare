# frozen_string_literal: true

require "test_helper"

module Simplecov
  module Compare
    describe FileComparison do
      describe "#same_file?" do
        it "is true when the file names of both file results are the same" do
          base = FileResult.new("name.txt", coverage_data: nil)
          other = FileResult.new("name.txt", coverage_data: nil)

          comparison = FileComparison.new(base, to: other)

          assert_equal true, comparison.same_file?
        end

        it "is false when the file names of both file results are different" do
          base = FileResult.new("name.txt", coverage_data: nil)
          other = FileResult.new("different.txt", coverage_data: nil)

          comparison = FileComparison.new(base, to: other)

          assert_equal false, comparison.same_file?
        end

        it "is false when there is no base" do
          other = FileResult.new("different.txt", coverage_data: nil)

          comparison = FileComparison.new(nil, to: other)

          assert_equal false, comparison.same_file?
        end
      end

      describe "#lines_coverage_equal?" do
        it "is true when the lines coverage is the same" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = FileComparison.new(base, to: other)

          assert_equal true, comparison.lines_coverage_equal?
        end

        it "is false when the lines coverage is different" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 6 }

          comparison = FileComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_equal?
        end
      end

      describe "#lines_coverage_increased?" do
        it "is true when the lines coverage of the other is higher" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 6 }

          comparison = FileComparison.new(base, to: other)

          assert_equal true, comparison.lines_coverage_increased?
        end

        it "is false when the lines coverage of the base is higher" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 6 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = FileComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_increased?
        end

        it "is false when the lines coverage is the same" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = FileComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_increased?
        end
      end

      describe "#lines_coverage_decreased?" do
        it "is true when the lines coverage of the base is higher" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 6 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = FileComparison.new(base, to: other)

          assert_equal true, comparison.lines_coverage_decreased?
        end

        it "is false when the lines coverage of the other is higher" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 6 }

          comparison = FileComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_decreased?
        end

        it "is false when the lines coverage is the same" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = FileComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_decreased?
        end
      end

      describe "#lines_coverage_delta_points" do
        it "is the positive difference between the base and the higher other coverage" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 50 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 60 }

          comparison = FileComparison.new(base, to: other)

          assert_equal 10, comparison.lines_coverage_delta_points
        end

        it "is the negative difference between the base and hte lower other coverage" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 60 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 50 }

          comparison = FileComparison.new(base, to: other)

          assert_equal(-10, comparison.lines_coverage_delta_points)
        end

        it "is a positive amount of the other lines coverage when there is no base" do
          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 50 }

          comparison = FileComparison.new(nil, to: other)

          assert_equal(50, comparison.lines_coverage_delta_points)
        end

        it "is a negative amount of the base lines coverage when there is no other" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 50 }

          comparison = FileComparison.new(base, to: nil)

          assert_equal(-50, comparison.lines_coverage_delta_points)
        end
      end
    end
  end
end
