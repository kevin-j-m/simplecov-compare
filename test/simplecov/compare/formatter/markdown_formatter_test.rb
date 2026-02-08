# frozen_string_literal: true

require "test_helper"

module Simplecov
  module Compare
    module Formatter
      describe MarkdownFormatter do
        describe "#format" do
          it "is a string of text in markdown describing the difference between two coverage reports with the biggest decreases in coverage in files at the top" do
            comparison = Mocktail.of(ResultSetComparison)
            stubs { comparison.original_lines_covered_percent }.with { 33 }
            stubs { comparison.new_lines_covered_percent }.with { 42 }
            stubs { comparison.lines_coverage_increased? }.with { true }
            stubs { comparison.lines_coverage_delta_points }.with { 9 }
            stubs { comparison.file_differences? }.with { true }

            big_decrease = Mocktail.of(FileComparison)
            stubs { big_decrease.filename }.with { "big_decrease.rb" }
            stubs { big_decrease.lines_coverage_delta_points }.with { -20 }
            small_decrease = Mocktail.of(FileComparison)
            stubs { small_decrease.filename }.with { "small_decrease.rb" }
            stubs { small_decrease.lines_coverage_delta_points }.with { -3 }
            small_increase = Mocktail.of(FileComparison)
            stubs { small_increase.filename }.with { "small_increase.rb" }
            stubs { small_increase.lines_coverage_delta_points }.with { 7 }
            big_increase = Mocktail.of(FileComparison)
            stubs { big_increase.filename }.with { "big_increase.rb" }
            stubs { big_increase.lines_coverage_delta_points }.with { 25 }

            stubs { comparison.file_differences }.with { [big_increase, small_decrease, big_decrease, small_increase] }

            markdown_result = <<~MARKDOWN
              # Coverage Comparison

              ## Overall Impact: 📈

              Coverage increased 9 points from 33% to 42%.

              ## File Differences

              | File Name | Coverage Change |
              | --------- | --------------- |
              | big_decrease.rb | -20 |
              | small_decrease.rb | -3 |
              | small_increase.rb | 7 |
              | big_increase.rb | 25 |


            MARKDOWN

            formatter = MarkdownFormatter.new

            assert_equal markdown_result, formatter.format(comparison)
          end

          it "shows a positive change when the coverage increased" do
            comparison = Mocktail.of(ResultSetComparison)
            stubs { comparison.original_lines_covered_percent }.with { 33 }
            stubs { comparison.new_lines_covered_percent }.with { 42 }
            stubs { comparison.lines_coverage_increased? }.with { true }
            stubs { comparison.lines_coverage_delta_points }.with { 9 }

            formatter = MarkdownFormatter.new

            assert_includes formatter.format(comparison), "## Overall Impact: 📈\n\nCoverage increased 9 points from 33% to 42%."
          end

          it "shows a negative change when the coverage decreased" do
            comparison = Mocktail.of(ResultSetComparison)
            stubs { comparison.original_lines_covered_percent }.with { 42 }
            stubs { comparison.new_lines_covered_percent }.with { 33 }
            stubs { comparison.lines_coverage_increased? }.with { false }
            stubs { comparison.lines_coverage_decreased? }.with { true }
            stubs { comparison.lines_coverage_delta_points }.with { -9 }

            formatter = MarkdownFormatter.new

            assert_includes formatter.format(comparison), "## Overall Impact: 📉\n\nCoverage decreased 9 points from 42% to 33%."
          end

          it "shows no change when the coverage is the same" do
            comparison = Mocktail.of(ResultSetComparison)
            stubs { comparison.original_lines_covered_percent }.with { 33 }
            stubs { comparison.new_lines_covered_percent }.with { 33 }
            stubs { comparison.lines_coverage_increased? }.with { false }
            stubs { comparison.lines_coverage_decreased? }.with { false }
            formatter = MarkdownFormatter.new

            assert_includes formatter.format(comparison), "## Overall Impact: 🟰\n\nCoverage maintained at 33%."
          end

          it "tells that all files have the same coverage when there are no file differences" do
            comparison = Mocktail.of(ResultSetComparison)
            stubs { comparison.file_differences? }.with { false }

            formatter = MarkdownFormatter.new

            assert_includes formatter.format(comparison), "## File Differences\n\nAll files maintained the same level of coverage."
          end
        end
      end
    end
  end
end
