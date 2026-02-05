# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../../lib/simplecov/compare/file_result"

module Simplecov
  module Compare
    describe FileResult do
      describe "#lines" do
        it "converts the lines coverage data into a collection of file lines" do
          coverage_data = { "lines" => [0, 1, nil, 47] }
          file = FileResult.new(nil, coverage_data:)

          assert_equal 4, file.lines.size
          assert_equal FileLine, file.lines.first.class
          assert_equal [1, 2, 3, 4], file.lines.map { _1.line_number }
          assert_equal [false, true, false, true], file.lines.map { _1.covered? }
        end

        it "is an empty collection when no coverage data is provided" do
          file = FileResult.new(nil, coverage_data: nil)

          assert_empty file.lines
        end

        it "is an empty collection with no lines coverage" do
          file = FileResult.new(nil, coverage_data: {})

          assert_empty file.lines
        end
      end

      describe "#relevant_lines" do
        it "provides the lines with relevant coverage information" do
          coverage_data = { "lines" => [0, 1, nil, 47] }
          file = FileResult.new(nil, coverage_data:)

          assert_equal [1, 2, 4], file.relevant_lines.map { _1.line_number }
        end
      end

      describe "#covered_lines" do
        it "provides the lines that have been covered in the coverage report" do
          coverage_data = { "lines" => [0, 1, nil, 47] }
          file = FileResult.new(nil, coverage_data:)

          assert_equal [2, 4], file.covered_lines.map { _1.line_number }
        end
      end

      describe "#lines_covered_percent" do
        it "is the percentage of relevant lines in the file that have been covered" do
          coverage_data = { "lines" => [0, 1, nil, 47] }
          file = FileResult.new(nil, coverage_data:)

          assert_equal 66.67, file.lines_covered_percent
        end

        it "is 100 when there are no relevant lines" do
          file = FileResult.new(nil, coverage_data: nil)

          assert_equal 100, file.lines_covered_percent
        end
      end
    end
  end
end
