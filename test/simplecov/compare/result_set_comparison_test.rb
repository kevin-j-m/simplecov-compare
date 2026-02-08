# frozen_string_literal: true

require "test_helper"

module Simplecov
  module Compare
    describe ResultSetComparison do
      describe "#original_lines_covered_percent" do
        it "is the lines covered percent of the base" do
          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 33.42 }

          comparison = ResultSetComparison.new(base, to: nil)

          assert_equal 33.42, comparison.original_lines_covered_percent
        end
      end

      describe "#new_lines_covered_percent" do
        it "is the lines covered percent of the comparison" do
          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 42.33 }

          comparison = ResultSetComparison.new(nil, to: other)

          assert_equal 42.33, comparison.new_lines_covered_percent
        end
      end

      describe "#lines_coverage_increased?" do
        it "is true when the lines coverage of the other is higher" do
          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 6 }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal true, comparison.lines_coverage_increased?
        end

        it "is false when the lines coverage of the base is higher" do
          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 6 }

          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_increased?
        end

        it "is false when the lines coverage is the same" do
          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_increased?
        end
      end

      describe "#lines_coverage_decreased?" do
        it "is true when the lines coverage of the base is higher" do
          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 6 }

          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal true, comparison.lines_coverage_decreased?
        end

        it "is false when the lines coverage of the other is higher" do
          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 6 }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_decreased?
        end

        it "is false when the lines coverage is the same" do
          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_decreased?
        end
      end

      describe "#lines_coverage_delta_points" do
        it "is the positive difference between coverage values when the other result has higher coverage" do

          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 33 }
          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 42 }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal 9, comparison.lines_coverage_delta_points
        end

        it "is the negative difference between coverage values when the other result has higher coverage" do
          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 33 }
          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 30 }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal -3, comparison.lines_coverage_delta_points
        end

        it "is a positive amount of the other lines coverage when there is no base" do
          other = Mocktail.of(ResultSet)
          stubs { other.lines_covered_percent }.with { 30 }

          comparison = ResultSetComparison.new(nil, to: other)

          assert_equal 30, comparison.lines_coverage_delta_points
        end

        it "is a negative amount of the base lines coverage when there is no other" do
          base = Mocktail.of(ResultSet)
          stubs { base.lines_covered_percent }.with { 33 }

          comparison = ResultSetComparison.new(base, to: nil)

          assert_equal(-33, comparison.lines_coverage_delta_points)
        end
      end

      describe "#file_differences" do
        it "is an empty collection when the result sets are the same" do

          base = ResultSet.new(file_path: "test/fixtures/sample_resultset.json")
          other = ResultSet.new(file_path: "test/fixtures/sample_resultset.json")

          comparison = ResultSetComparison.new(base, to: other)

          assert_empty comparison.file_differences
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

          assert_equal 1, comparison.file_differences.size

          difference = comparison.file_differences.first
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

          assert_equal 1, comparison.file_differences.size

          difference = comparison.file_differences.first
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

          assert_equal 1, comparison.file_differences.size

          difference = comparison.file_differences.first
          assert_equal "file.rb", difference.filename
          assert_equal(50, difference.lines_coverage_delta_points)
        end
      end

      describe "#file_differences?" do
        it "is true when a file is different between the result sets" do
          base_file = Mocktail.of(FileResult)
          stubs { base_file.lines_covered_percent }.with { 5 }
          stubs { base_file.filename }.with { "base.rb" }

          base = Mocktail.of(ResultSet)
          stubs { base.files }.with { [base_file] }

          other = Mocktail.of(ResultSet)
          stubs { other.files }.with { [] }

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal true, comparison.file_differences?
        end

        it "is false when every file is the same" do
          base = ResultSet.new(file_path: "test/fixtures/sample_resultset.json")
          other = ResultSet.new(file_path: "test/fixtures/sample_resultset.json")

          comparison = ResultSetComparison.new(base, to: other)

          assert_equal false, comparison.file_differences?
        end
      end
    end
  end
end
