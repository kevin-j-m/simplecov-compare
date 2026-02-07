# frozen_string_literal: true

require "test_helper"

module Simplecov
  module Compare
    describe ResultSetComparison do
      describe "#differences" do
        it "is an empty collection when the result sets are the same" do

          base = ResultSet.new("test/fixtures/sample_resultset.json")
          other = ResultSet.new("test/fixtures/sample_resultset.json")

          comparison = ResultSetComparison.new(base, to: other)

          assert_empty comparison.differences
        end

        it "includes files in the base not in the comparison as decreased coverage" do
          base_file = Mocktail.of(FileResult)
          stubs { base_file.lines_covered_percent }.with { 5 }
          stubs { base_file.filename }.with { "base.rb" }

          base = Mocktail.of(ResultSet)
          stubs { base.files }.with { [base_file] }

          other = Mocktail.of(ResultSet)
          stubs { other.files }.with { [] }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal 1, comparison.differences.size

          difference = comparison.differences.first
          assert_equal "base.rb", difference.filename
          assert_equal(-5, difference.lines_coverage_delta_points)
        end

        it "includes files in the comparison not in the base as increased coverage" do
          base = Mocktail.of(ResultSet)
          stubs { base.files }.with { [] }

          other_file = Mocktail.of(FileResult)
          stubs { other_file.lines_covered_percent }.with { 5 }
          stubs { other_file.filename }.with { "other.rb" }

          other = Mocktail.of(ResultSet)
          stubs { other.files }.with { [other_file] }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal 1, comparison.differences.size

          difference = comparison.differences.first
          assert_equal "other.rb", difference.filename
          assert_equal(5, difference.lines_coverage_delta_points)
        end

        it "includes files in both result sets where the coverage changed" do
          base_file = FileResult.new("file.rb", coverage_data: { "lines" => [0, 1] })

          base = Mocktail.of(ResultSet)
          stubs { base.files }.with { [base_file] }

          other_file = FileResult.new("file.rb", coverage_data: { "lines" => [1, 1] })

          other = Mocktail.of(ResultSet)
          stubs { other.files }.with { [other_file] }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal 1, comparison.differences.size

          difference = comparison.differences.first
          assert_equal "file.rb", difference.filename
          assert_equal(50, difference.lines_coverage_delta_points)
        end
      end
    end
  end
end
