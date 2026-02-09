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

      describe "#filename" do
        it "is the name of the base file when base exists" do
          base = FileResult.new("name.txt", coverage_data: nil)
          other = FileResult.new("different.txt", coverage_data: nil)

          comparison = FileComparison.new(base, to: other)

          assert_equal "name.txt", comparison.filename
        end

        it "is the name of the other file when there is no base" do
          other = FileResult.new("different.txt", coverage_data: nil)

          comparison = FileComparison.new(nil, to: other)

          assert_equal "different.txt", comparison.filename
        end

        it "is nil when there is neither a base nor another file" do
          comparison = FileComparison.new(nil, to: nil)

          assert_nil comparison.filename
        end
      end

      describe "#lines_coverage_different?" do
        it "is true when the lines coverage is different" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 6 }

          comparison = FileComparison.new(base, to: other)

          assert_equal true, comparison.lines_coverage_different?
        end

        it "is false when the lines coverage is the same" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 5 }

          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 5 }

          comparison = FileComparison.new(base, to: other)

          assert_equal false, comparison.lines_coverage_different?
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

        it "is the negative difference between the base and the lower other coverage" do
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

      describe "#original_lines_covered_percent" do
        it "is the lines coverage of the base file" do
          base = Mocktail.of(FileResult)
          stubs { base.lines_covered_percent }.with { 50 }

          comparison = FileComparison.new(base, to: nil)

          assert_equal 50, comparison.original_lines_covered_percent
        end
      end

      describe "#new_lines_covered_percent" do
        it "is the lines coverage of the comparison file" do
          other = Mocktail.of(FileResult)
          stubs { other.lines_covered_percent }.with { 75 }

          comparison = FileComparison.new(nil, to: other)

          assert_equal 75, comparison.new_lines_covered_percent
        end
      end

      describe "#original_num_relevant_lines" do
        it "is the number of relevant lines of the base file" do
          base = Mocktail.of(FileResult)
          stubs { base.num_relevant_lines }.with { 33 }

          comparison = FileComparison.new(base, to: nil)

          assert_equal 33, comparison.original_num_relevant_lines
        end
      end

      describe "#original_num_covered_lines" do
        it "is the number of covered lines of the base file" do
          base = Mocktail.of(FileResult)
          stubs { base.num_covered_lines }.with { 17 }

          comparison = FileComparison.new(base, to: nil)

          assert_equal 17, comparison.original_num_covered_lines
        end
      end

      describe "#new_num_relevant_lines" do
        it "is the number of relevant lines of the comparison file" do
          other = Mocktail.of(FileResult)
          stubs { other.num_relevant_lines }.with { 42 }

          comparison = FileComparison.new(nil, to: other)

          assert_equal 42, comparison.new_num_relevant_lines
        end
      end

      describe "#new_num_covered_lines" do
        it "is the number of covered lines of the comparison file" do
          other = Mocktail.of(FileResult)
          stubs { other.num_covered_lines }.with { 71 }

          comparison = FileComparison.new(nil, to: other)

          assert_equal 71, comparison.new_num_covered_lines
        end
      end

    end
  end
end
